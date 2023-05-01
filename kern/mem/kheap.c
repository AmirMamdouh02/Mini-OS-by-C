#include "kheap.h"

#include <inc/memlayout.h>
#include <inc/dynamic_allocator.h>
#include "memory_manager.h"

//==================================================================//
//==================================================================//
//NOTE: All kernel heap allocations are multiples of PAGE_SIZE (4KB)//
//==================================================================//
//==================================================================//

void initialize_dyn_block_system()
{

		       //TODO: [PROJECT MS2] [KERNEL HEAP] initialize_dyn_block_system
				// your code is here, remove the panic and write your code
				//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
			        LIST_INIT(&AllocMemBlocksList);
			        LIST_INIT(&FreeMemBlocksList);
			#if STATIC_MEMBLOCK_ALLOC
				//DO NOTHING
			#else
						MAX_MEM_BLOCK_CNT=NUM_OF_KHEAP_PAGES;
						MemBlockNodes=(struct MemBlock*)KERNEL_HEAP_START;//
						uint32 size=sizeof(struct MemBlock);//
						uint32 newsize=size*MAX_MEM_BLOCK_CNT;
						newsize = ROUNDUP(newsize ,PAGE_SIZE );
						allocate_chunk(ptr_page_directory,KERNEL_HEAP_START,newsize,PERM_WRITEABLE);
				/*[2] Dynamically allocate the array of MemBlockNodes
				 * 	remember to:
				 * 		1. set MAX_MEM_BLOCK_CNT with the chosen size of the array
				 * 		2. allocation should be aligned on PAGE boundary
				 * 	HINT: can use alloc_chunk(...) function
				 */
			#endif

				initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
					struct MemBlock *temp =LIST_LAST(&AvailableMemBlocksList);
					LIST_REMOVE(&AvailableMemBlocksList , temp);
					temp->size=(KERNEL_HEAP_MAX-KERNEL_HEAP_START)-newsize;
					temp->sva = KERNEL_HEAP_START+newsize;
					LIST_INSERT_HEAD( &FreeMemBlocksList ,temp );


				//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
				//[4] Insert a new MemBlock with the remaining heap size into the FreeMemBlocksList

				//(KERNEL_HEAP_MAX-KERNEL_HEAP_START)/PAGE_SIZE;







	}

void* kmalloc(unsigned int size)
{
//kpanic_into_prompt("kmalloc() is not implemented yet...!!");
	size = ROUNDUP(size , PAGE_SIZE);
		struct MemBlock *mem_block = NULL;
		if ((KERNEL_HEAP_MAX-KERNEL_HEAP_START) < size){
			return NULL ;
		}
		if (isKHeapPlacementStrategyFIRSTFIT()){
			mem_block = alloc_block_FF(size);
		}else{
			mem_block = alloc_block_BF(size);
		}
		if (mem_block != NULL){
			int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);
			if (s == 0 ){
				LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
				return (void *)mem_block->sva ;
			}else{
				return NULL;
			}
		}else{
			return NULL;
		}

	}




	//TODO: [PROJECT MS2] [KERNEL HEAP] kmalloc
	// your code is here, remove the panic and write your code

	//refer to the project presentation and documentation for details
	//NOTE: All kernel heap allocations are multiples of PAGE_SIZE (4KB)
	// use "isKHeapPlacementStrategyFIRSTFIT() ..." functions to check the current strategy

	//change this "return" according to your answer


void kfree(void* virtual_address)
{
	//kpanic_into_prompt("kmalloc() is not implemented yet...!!");

	if(virtual_address < (void*)KERNEL_HEAP_MAX && virtual_address >= (void*)KERNEL_HEAP_START){
	struct MemBlock *ptr=find_block(&AllocMemBlocksList,(uint32)virtual_address);


	if(ptr!=NULL){
	LIST_REMOVE(&AllocMemBlocksList,ptr);

	for(uint32 i=ROUNDDOWN(ptr->sva,PAGE_SIZE) ; i<ROUNDUP(ptr->sva+ptr->size,PAGE_SIZE) ; i+=PAGE_SIZE){
		unmap_frame(ptr_page_directory,i);
	}
	insert_sorted_with_merge_freeList(ptr);
}
}

}

unsigned int kheap_virtual_address(unsigned int physical_address)
{
	//panic("kheap_virtual_address() is not implemented yet...!!");
	struct FrameInfo *va=to_frame_info(physical_address);
	return va->va;

	//TODO: [PROJECT MS2] [KERNEL HEAP] kheap_virtual_address
	//Write your code here, remove the panic and write your code

	//return the virtual address corresponding to given physical_address
	//refer to the project presentation and documentation for details
	//EFFICIENT IMPLEMENTATION ~O(1) IS REQUIRED ==================
}

unsigned int kheap_physical_address(unsigned int virtual_address)
{
	//panic("kheap_physical_address() is not implemented yet...!!");
	int ret_address =virtual_to_physical(ptr_page_directory,virtual_address);
	return ret_address;

	//TODO: [PROJECT MS2] [KERNEL HEAP] kheap_physical_address
	// Write your code here, remove the panic and write your code

	//return the physical address corresponding to given virtual_address
	//refer to the project presentation and documentation for details
}


void kfreeall()
{
	panic("Not implemented!");

}

void kshrink(uint32 newSize)
{
	panic("Not implemented!");
}

void kexpand(uint32 newSize)
{
	panic("Not implemented!");
}




//=================================================================================//
//============================== BONUS FUNCTION ===================================//
//=================================================================================//
// krealloc():

//	Attempts to resize the allocated space at "virtual_address" to "new_size" bytes,
//	possibly moving it in the heap.
//	If successful, returns the new virtual_address, in which case the old virtual_address must no longer be accessed.
//	On failure, returns a null pointer, and the old virtual_address remains valid.

//	A call with virtual_address = null is equivalent to kmalloc().
//	A call with new_size = zero is equivalent to kfree().

void *krealloc(void *virtual_address, uint32 new_size)
{
	//TODO: [PROJECT MS2 - BONUS] [KERNEL HEAP] krealloc
	// Write your code here, remove the panic and write your code
	panic("krealloc() is not implemented yet...!!");
}
