/*
 * fault_handler.c
 *
 *  Created on: Oct 12, 2022
 *      Author: HP
 */

#include "trap.h"
#include <kern/proc/user_environment.h>
#include "../cpu/sched.h"
#include "../disk/pagefile_manager.h"
#include "../mem/memory_manager.h"

//2014 Test Free(): Set it to bypass the PAGE FAULT on an instruction with this length and continue executing the next one
// 0 means don't bypass the PAGE FAULT
uint8 bypassInstrLength = 0;

//===============================
// REPLACEMENT STRATEGIES
//===============================
//2020
void setPageReplacmentAlgorithmLRU(int LRU_TYPE)
{
	assert(LRU_TYPE == PG_REP_LRU_TIME_APPROX || LRU_TYPE == PG_REP_LRU_LISTS_APPROX);
	_PageRepAlgoType = LRU_TYPE ;
}
void setPageReplacmentAlgorithmCLOCK(){_PageRepAlgoType = PG_REP_CLOCK;}
void setPageReplacmentAlgorithmFIFO(){_PageRepAlgoType = PG_REP_FIFO;}
void setPageReplacmentAlgorithmModifiedCLOCK(){_PageRepAlgoType = PG_REP_MODIFIEDCLOCK;}
/*2018*/ void setPageReplacmentAlgorithmDynamicLocal(){_PageRepAlgoType = PG_REP_DYNAMIC_LOCAL;}
/*2021*/ void setPageReplacmentAlgorithmNchanceCLOCK(int PageWSMaxSweeps){_PageRepAlgoType = PG_REP_NchanceCLOCK;  page_WS_max_sweeps = PageWSMaxSweeps;}

//2020
uint32 isPageReplacmentAlgorithmLRU(int LRU_TYPE){return _PageRepAlgoType == LRU_TYPE ? 1 : 0;}
uint32 isPageReplacmentAlgorithmCLOCK(){if(_PageRepAlgoType == PG_REP_CLOCK) return 1; return 0;}
uint32 isPageReplacmentAlgorithmFIFO(){if(_PageRepAlgoType == PG_REP_FIFO) return 1; return 0;}
uint32 isPageReplacmentAlgorithmModifiedCLOCK(){if(_PageRepAlgoType == PG_REP_MODIFIEDCLOCK) return 1; return 0;}
/*2018*/ uint32 isPageReplacmentAlgorithmDynamicLocal(){if(_PageRepAlgoType == PG_REP_DYNAMIC_LOCAL) return 1; return 0;}
/*2021*/ uint32 isPageReplacmentAlgorithmNchanceCLOCK(){if(_PageRepAlgoType == PG_REP_NchanceCLOCK) return 1; return 0;}

//===============================
// PAGE BUFFERING
//===============================
void enableModifiedBuffer(uint32 enableIt){_EnableModifiedBuffer = enableIt;}
uint8 isModifiedBufferEnabled(){  return _EnableModifiedBuffer ; }

void enableBuffering(uint32 enableIt){_EnableBuffering = enableIt;}
uint8 isBufferingEnabled(){  return _EnableBuffering ; }

void setModifiedBufferLength(uint32 length) { _ModifiedBufferLength = length;}
uint32 getModifiedBufferLength() { return _ModifiedBufferLength;}

//===============================
// FAULT HANDLERS
//===============================

//Handle the table fault
void table_fault_handler(struct Env * curenv, uint32 fault_va)
{
	//panic("table_fault_handler() is not implemented yet...!!");
	//Check if it's a stack page
	uint32* ptr_table;
#if USE_KHEAP
	{
		ptr_table = create_page_table(curenv->env_page_directory, (uint32)fault_va);
	}
#else
	{
		__static_cpt(curenv->env_page_directory, (uint32)fault_va, &ptr_table);
	}
#endif
}

//Handle the page fault

void page_fault_handler(struct Env * curenv, uint32 fault_va)
{
	//TODO: [PROJECT MS3] [FAULT HANDLER] page_fault_handler
	// Write your code here, remove the panic and write your code
	fault_va = ROUNDDOWN(fault_va ,PAGE_SIZE );
	    	if(env_page_ws_get_size(curenv) < curenv->page_WS_max_size){
	        uint32 alloc_pa = pf_read_env_page(curenv , (void *)fault_va);
	        struct FrameInfo *to_allocate = NULL ;
	        allocate_frame(&to_allocate);
	        map_frame(curenv->env_page_directory ,to_allocate,fault_va , PERM_USER|PERM_WRITEABLE|PERM_PRESENT );
	        if(alloc_pa == E_PAGE_NOT_EXIST_IN_PF){
	            if (( fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX) ||(fault_va <= USTACKTOP && fault_va >= USTACKBOTTOM) ){

	            }else{
	                panic("ILLEGAL MEMORY ACCESS");
	            }
	        }
	        env_page_ws_set_entry(curenv ,curenv->page_last_WS_index , fault_va);
	        curenv->page_last_WS_index = curenv->page_last_WS_index + 1 ;
	        curenv->page_last_WS_index = curenv->page_last_WS_index % curenv->page_WS_max_size;
	    	}
	    	else{
	    	struct FrameInfo *to_frame = NULL;
	    	uint32 *pointer = NULL;
	    	while(1==1){
	    		uint32 vir_last = curenv->ptr_pageWorkingSet[curenv->page_last_WS_index].virtual_address;
	    		to_frame = get_frame_info(curenv->env_page_directory , vir_last ,&pointer );
	    		uint32 permession = pt_get_page_permissions(curenv->env_page_directory , vir_last);
	    		if((permession & PERM_USED) != PERM_USED){
	    			if((permession & PERM_MODIFIED)== PERM_MODIFIED){
	    				pf_update_env_page(curenv , vir_last , to_frame );
	    		    }
	    			unmap_frame(curenv->env_page_directory , vir_last);
	    			env_page_ws_clear_entry(curenv , curenv->page_last_WS_index);
	    			if(env_page_ws_get_size(curenv) < curenv->page_WS_max_size){
	    			allocate_frame(&to_frame);
	    			map_frame(curenv->env_page_directory ,to_frame,fault_va , PERM_USER|PERM_WRITEABLE|PERM_PRESENT );
	    			uint32 alloc_pa = pf_read_env_page(curenv , (void *)fault_va); if(alloc_pa == E_PAGE_NOT_EXIST_IN_PF){
	    			if ((fault_va <= USTACKTOP && fault_va >= USTACKBOTTOM) || (fault_va >= USER_HEAP_START && fault_va < USER_HEAP_MAX)){
	    			}else{
	    			panic("ILLEGAL MEMORY ACCESS");
	    			   }
	    			}
	    			env_page_ws_set_entry(curenv ,curenv->page_last_WS_index , fault_va);
	    			curenv->page_last_WS_index = curenv->page_last_WS_index + 1 ;
	    			curenv->page_last_WS_index = curenv->page_last_WS_index % curenv->page_WS_max_size;
	    			        }
	    			break;
	    			}else{
	    			pt_set_page_permissions(curenv->env_page_directory , vir_last ,0 , PERM_USED);
	    			curenv->page_last_WS_index = curenv->page_last_WS_index + 1 ;
	    			curenv->page_last_WS_index = curenv->page_last_WS_index % curenv->page_WS_max_size;
	    			}
	    		}
	    	}
	    }

	//TODO: [PROJECT MS3] [FAULT HANDLER] page_fault_handler
	// Write your code here, remove the panic and write your code
	//panic("page_fault_handler() is not implemented yet...!!");
	//refer to the project presentation and documentation for details

void __page_fault_handler_with_buffering(struct Env * curenv, uint32 fault_va)
{
	// Write your code here, remove the panic and write your code
	panic("__page_fault_handler_with_buffering() is not implemented yet...!!");


}







