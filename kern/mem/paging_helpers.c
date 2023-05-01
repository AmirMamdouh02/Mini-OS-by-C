/*
 * paging_helpers.c
 *
 *  Created on: Sep 30, 2022
 *      Author: HP
 */
#include "memory_manager.h"

/*[2.1] PAGE TABLE ENTRIES MANIPULATION */
inline void pt_set_page_permissions(uint32* page_directory, uint32 virtual_address, uint32 permissions_to_set, uint32 permissions_to_clear)
{
	uint32 *ptr_page_table=NULL;
	get_page_table(page_directory,virtual_address,&ptr_page_table);
	if(ptr_page_table!=NULL){
		uint32 x=PTX(virtual_address);
		if(permissions_to_set){
			ptr_page_table[x]=ptr_page_table[x]|permissions_to_set;
		}
		if(permissions_to_clear){
			ptr_page_table[x]=ptr_page_table[x]&~permissions_to_clear;
		}
		tlb_invalidate((void*)NULL,(void*)virtual_address);
		}

	else{
		panic("invalid set \n");
		}


	}

inline int pt_get_page_permissions(uint32* page_directory, uint32 virtual_address )
{

	uint32 *ptr_page_table=NULL;
	get_page_table(page_directory,virtual_address,&ptr_page_table);
	if(ptr_page_table!=NULL){
		uint32 table_entry =PTX(virtual_address);
		uint32 address =ptr_page_table[table_entry]<<20;
		address=address>>20;
		return address;
	}

		return -1;

}

inline void pt_clear_page_table_entry(uint32* page_directory, uint32 virtual_address)
{
	uint32 x=PTX(virtual_address);
	uint32 *ptr_page_table=NULL;

	uint32 y=get_page_table(page_directory,virtual_address,&ptr_page_table);
	if(ptr_page_table!=NULL){
//ptr_page_table[x]=0;
		ptr_page_table[x]=ptr_page_table[x]&0;
		tlb_invalidate((void*)NULL,(void*)virtual_address);
	}else{
		panic("invalid clear \n");
		}

	//TODO: [PROJECT MS2] [PAGING HELPERS] pt_clear_page_table_entry
	// Write your code here, remove the panic and write your code
	//panic("pt_clear_page_table_entry() is not implemented yet...!!");
}

/***********************************************************************************************/

/*[2.2] ADDRESS CONVERTION*/
inline int virtual_to_physical(uint32* page_directory, uint32 virtual_address)
{
	uint32 *ptr_page_table=NULL;
	get_page_table(page_directory,virtual_address,&ptr_page_table);
	if(ptr_page_table!=NULL){
	uint32 table_entry = PTX(virtual_address);
    uint32 entry =	ptr_page_table[table_entry];
	uint32 framenum = entry>>12;
	uint32 address=(framenum*PAGE_SIZE);
		return address;
	}
	return -1;


	//TODO: [PROJECT MS2] [PAGING HELPERS] virtual_to_physical
	// Write your code here, remove the panic and write your code
//	panic("virtual_to_physical() is not implemented yet...!!");
}

/***********************************************************************************************/

/***********************************************************************************************/
/***********************************************************************************************/
/***********************************************************************************************/
/***********************************************************************************************/
/***********************************************************************************************/

///============================================================================================
/// Dealing with page directory entry flags

inline uint32 pd_is_table_used(uint32* page_directory, uint32 virtual_address)
{
	return ( (page_directory[PDX(virtual_address)] & PERM_USED) == PERM_USED ? 1 : 0);
}

inline void pd_set_table_unused(uint32* page_directory, uint32 virtual_address)
{
	page_directory[PDX(virtual_address)] &= (~PERM_USED);
	tlb_invalidate((void *)NULL, (void *)virtual_address);
}

inline void pd_clear_page_dir_entry(uint32* page_directory, uint32 virtual_address)
{
	page_directory[PDX(virtual_address)] = 0 ;
	tlbflush();
}
