/*
 * chunk_operations.c
 *
 *  Created on: Oct 12, 2022
 *      Author: HP
 */

#include <kern/trap/fault_handler.h>
#include <kern/disk/pagefile_manager.h>
#include "kheap.h"
#include "memory_manager.h"


/******************************/
/*[1] RAM CHUNKS MANIPULATION */
/******************************/

//===============================
// 1) CUT-PASTE PAGES IN RAM:
//===============================
//This function should cut-paste the given number of pages from source_va to dest_va
//if the page table at any destination page in the range is not exist, it should create it
//Hint: use ROUNDDOWN/ROUNDUP macros to align the addresses
int cut_paste_pages(uint32* page_directory, uint32 source_va, uint32 dest_va, uint32 num_of_pages)
{

		  uint32 endsrc_va = source_va +(num_of_pages*PAGE_SIZE);
		  uint32 end_distva= dest_va + (num_of_pages*PAGE_SIZE);
		  source_va=ROUNDDOWN(source_va,PAGE_SIZE);
		  endsrc_va=ROUNDUP(endsrc_va,PAGE_SIZE);
		  dest_va=ROUNDDOWN(dest_va,PAGE_SIZE);
		  end_distva=ROUNDUP(end_distva,PAGE_SIZE);

			uint32 *ptr_page_table1=NULL;
			uint32*ptr1 =NULL;
				struct FrameInfo* ptrframeinfo;
				uint32 stoploop=dest_va;
				for( uint32 i=dest_va;i<end_distva;i += PAGE_SIZE){
				ptrframeinfo =get_frame_info(page_directory,i,&ptr1);
					if(ptrframeinfo!=NULL){
					return -1;
					}

							}

			uint32 *temp2=NULL;
			 for(uint32 i=0;i<num_of_pages;i++){
				uint32 dest_address = dest_va + i*PAGE_SIZE;
				uint32 source_address = source_va + i*PAGE_SIZE;
				uint32 en =	get_page_table(page_directory,dest_address,&temp2);
			 uint32 *ptr_page_table2=NULL;
		 if(en==TABLE_NOT_EXIST){
			 create_page_table(page_directory,dest_address);
		 }
		 struct FrameInfo *temp=get_frame_info(page_directory,source_address,&ptr_page_table2);
		uint32 table_entry =PTX(source_address);
		 uint32 PERMS =ptr_page_table2[table_entry]<<20;
			PERMS=PERMS>>20;
			map_frame(page_directory,temp,dest_address,PERMS);
			 unmap_frame(page_directory,source_address);



			 		 }

		 return 0;
		 }

	//TODO: [PROJECT MS2] [CHUNK OPERATIONS] cut_paste_pages
	// Write your code here, remove the panic and write your code
	//panic("cut_paste_pages() is not implemented yet...!!");


//===============================
// 2) COPY-PASTE RANGE IN RAM:
//===============================
//This function should copy-paste the given size from source_va to dest_va
//if the page table at any destination page in the range is not exist, it should create it
//Hint: use ROUNDDOWN/ROUNDUP macros to align the addresses
int copy_paste_chunk(uint32* page_directory, uint32 source_va, uint32 dest_va, uint32 size)
{
	//TODO: [PROJECT MS2] [CHUNK OPERATIONS] copy_paste_chunk
	// Write your code here, remove the panic and write your code
	panic("copy_paste_chunk() is not implemented yet...!!");
}

//===============================
// 3) SHARE RANGE IN RAM:
//===============================
//This function should share the given size from dest_va with the source_va
//Hint: use ROUNDDOWN/ROUNDUP macros to align the addresses
int share_chunk(uint32* page_directory, uint32 source_va,uint32 dest_va, uint32 size, uint32 perms)
{


    uint32 end_source = source_va +size;
	uint32 end_dest= dest_va +size;
	source_va =ROUNDDOWN(source_va,PAGE_SIZE);
	end_source=ROUNDUP(end_source,PAGE_SIZE);
	dest_va =ROUNDDOWN(dest_va,PAGE_SIZE);
	end_dest=ROUNDUP(end_dest,PAGE_SIZE);
		struct FrameInfo * ptr_frame_info;
		uint32 *ptr_page_table1=NULL;
		uint32*ptr1 =NULL;
	for(uint32 i=dest_va;i<end_dest;i += PAGE_SIZE){

		ptr_frame_info=get_frame_info(page_directory,i,&ptr1);
		if(ptr_frame_info!=NULL){

		return -1;
	}

	}
	uint32 *temp2=NULL;
	for(uint32 i=source_va, j=dest_va;i<end_source&&j<end_dest ;i+=PAGE_SIZE,j+=PAGE_SIZE){


	uint32 entries =get_page_table(page_directory,j,&temp2);
	 if(entries==TABLE_NOT_EXIST){
		 create_page_table(page_directory,j);
	 }
	 uint32 *ptr_page_table2=NULL;
struct FrameInfo *temp=get_frame_info(page_directory,i,&ptr_page_table2);
map_frame(page_directory,temp,j,perms);
}

return 0;
}






	//TODO: [PROJECT MS2] [CHUNK OPERATIONS] share_chunk
	// Write your code here, remove the panic and write your code
	//panic("share_chunk() is not implemented yet...!!");

//===============================
// 4) ALLOCATE CHUNK IN RAM:
//===============================
//This function should allocate in RAM the given range [va, va+size)
//Hint: use ROUNDDOWN/ROUNDUP macros to align the addresses
int allocate_chunk(uint32* page_directory, uint32 va, uint32 size, uint32 perms)
{
	uint32 endva = va+size;
	uint32 i;
	struct FrameInfo* ptrframeinfo;
	struct FrameInfo*ptr_frame_info;
	va=ROUNDDOWN(va,PAGE_SIZE);
	endva=ROUNDUP(endva,PAGE_SIZE );
		for( i=va;i<endva;i=i+PAGE_SIZE){
			uint32*ptr1 =NULL;
	ptrframeinfo =get_frame_info(page_directory,i,&ptr1);
			 if(ptrframeinfo!=NULL){
							return -1;
						}
				else if(ptrframeinfo==NULL){
					uint32*p=NULL;
				get_page_table(page_directory,i,&p);
				uint32*ptr2;
			int ret=allocate_frame(&ptr_frame_info);
			if(ret==E_NO_MEM){
				return -1;

			}else{
				map_frame(page_directory,ptr_frame_info,i,perms);
			}

			}
			 ptr_frame_info->va=i;

	}

		return 0;



	//TODO: [PROJECT MS2] [CHUNK OPERATIONS] allocate_chunk
	 //Write your code here, remove the panic and write your code
	//panic("allocate_chunk() is not implemented yet...!!");
}

/*BONUS*/
//=====================================
// 5) CALCULATE ALLOCATED SPACE IN RAM:
//=====================================
void calculate_allocated_space(uint32* page_directory, uint32 sva, uint32 eva, uint32 *num_tables, uint32 *num_pages)
{
	uint32 start_address = ROUNDDOWN(sva , PAGE_SIZE);
	uint32 end_address = ROUNDUP(eva , PAGE_SIZE);
	int sum_page = 0 ;
	int sum_table = 0;
	uint32 i ;
	for(i = start_address ; i < end_address ; i += PAGE_SIZE){
		struct FrameInfo *f ;
		uint32 *ptr1 = NULL ;
		f = get_frame_info(page_directory , i , &ptr1);
		if (f != NULL ){
			sum_page++;
		}
	}
	uint32 x = start_address =ROUNDDOWN(sva , PAGE_SIZE*1024);
	for(i = x ; i < end_address ; i += PAGE_SIZE*1024){
		uint32 *ptr2 = NULL ;
		int t_inmem = get_page_table(page_directory , i ,&ptr2);
					if(t_inmem == TABLE_IN_MEMORY){
						sum_table++ ;
		     	}
	}
*num_pages = sum_page ;
*num_tables = sum_table ;



	//TODO: [PROJECT MS2 - BONUS] [CHUNK OPERATIONS] calculate_allocated_space
	// Write your code here, remove the panic and write your code
	//panic("calculate_allocated_space() is not implemented yet...!!");
}

/*BONUS*/
//=====================================
// 6) CALCULATE REQUIRED FRAMES IN RAM:
//=====================================
// calculate_required_frames:
// calculates the new allocation size required for given address+size,
// we are not interested in knowing if pages or tables actually exist in memory or the page file,
// we are interested in knowing whether they are allocated or not.
uint32 calculate_required_frames(uint32* page_directory, uint32 sva, uint32 size)
{
	uint32 start_address_required = ROUNDDOWN(sva , PAGE_SIZE);
		uint32 end_address_required = ROUNDUP(sva+size , PAGE_SIZE);
		int sum_page_required = 0 ;
		int sum_table_required = 0;
		uint32 i ;
		for(i = start_address_required ; i < end_address_required ; i += PAGE_SIZE){
		struct FrameInfo *f ;
		uint32 *ptr1 = NULL ;
		f = get_frame_info(page_directory , i , &ptr1);
		if (f == NULL ){
				sum_page_required++;
			}
		}
		uint32 x = start_address_required =ROUNDDOWN(sva , PAGE_SIZE*1024);
		for(i = x ; i < end_address_required ; i += PAGE_SIZE*1024){
		uint32 *ptr2 = NULL ;
		int t_inmem = get_page_table(page_directory , i ,&ptr2);
		if(t_inmem != TABLE_IN_MEMORY){
					sum_table_required++ ;
			  }
		}
	return sum_page_required + sum_table_required ;


	//TODO: [PROJECT MS2 - BONUS] [CHUNK OPERATIONS] calculate_required_frames
	// Write your code here, remove the panic and write your code
//	panic("calculate_required_frames() is not implemented yet...!!");
}

//=================================================================================//
//===========================END RAM CHUNKS MANIPULATION ==========================//
//=================================================================================//

/*******************************/
/*[2] USER CHUNKS MANIPULATION */
/*******************************/

//======================================================
/// functions used for USER HEAP (malloc, free, ...)
//======================================================

//=====================================
// 1) ALLOCATE USER MEMORY:
//=====================================
void allocate_user_mem(struct Env* e, uint32 virtual_address, uint32 size)
{
	// Write your code here, remove the panic and write your code
	panic("allocate_user_mem() is not implemented yet...!!");
}

//=====================================
// 2) FREE USER MEMORY:
//=====================================
void free_user_mem(struct Env* e, uint32 virtual_address, uint32 size)
{
	//TODO: [PROJECT MS3] [USER HEAP - KERNEL SIDE] free_user_mem
		// Write your code here, remove the panic and write your code
		//This function should:
		//1. Free ALL pages of the given range from the Page File
		//2. Free ONLY pages that are resident in the working set from the memory

		//uint32 start=ROUNDDOWN(virtual_address,PAGE_SIZE);
		//uint32 end=ROUNDUP(virtual_address+size,PAGE_SIZE);
		for(int i=virtual_address;i<virtual_address+size;i+=PAGE_SIZE){
			unmap_frame(e->env_page_directory,i);
			env_page_ws_invalidate(e, i);
			pf_remove_env_page(e, i);
		}

		//3. Removes ONLY the empty page tables (i.e. not used) (no pages are mapped in the table)

		for(int i=virtual_address;i<virtual_address+size;i+=PAGE_SIZE)
		{
			uint32 *ptr_page_table = NULL;
			int ret = get_page_table(e->env_page_directory, i, &ptr_page_table);
			int c=0;
			if(ret!=TABLE_NOT_EXIST)
			{
				for(int j=0;j<1024;j++)
				{
					if(ptr_page_table[j]==0)
					{
						c++;
					}
				}
				//cprintf("c value = %d \n", c);
				if(c==1024)
				{
					//cprintf("free table \n");
					kfree(ptr_page_table);
					pd_clear_page_dir_entry(e->env_page_directory,i);
				}
			}
		}

	//This function should:
	//1. Free ALL pages of the given range from the Page File
	//2. Free ONLY pages that are resident in the working set from the memory
	//3. Removes ONLY the empty page tables (i.e. not used) (no pages are mapped in the table)
}

//=====================================
// 2) FREE USER MEMORY (BUFFERING):
//=====================================
void __free_user_mem_with_buffering(struct Env* e, uint32 virtual_address, uint32 size)
{
	// your code is here, remove the panic and write your code
	panic("__free_user_mem_with_buffering() is not implemented yet...!!");

	//This function should:
	//1. Free ALL pages of the given range from the Page File
	//2. Free ONLY pages that are resident in the working set from the memory
	//3. Free any BUFFERED pages in the given range
	//4. Removes ONLY the empty page tables (i.e. not used) (no pages are mapped in the table)
}

//=====================================
// 3) MOVE USER MEMORY:
//=====================================
void move_user_mem(struct Env* e, uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
	//TODO: [PROJECT MS3 - BONUS] [USER HEAP - KERNEL SIDE] move_user_mem
	//your code is here, remove the panic and write your code
	panic("move_user_mem() is not implemented yet...!!");

	// This function should move all pages from "src_virtual_address" to "dst_virtual_address"
	// with the given size
	// After finished, the src_virtual_address must no longer be accessed/exist in either page file
	// or main memory

	/**/
}

//=================================================================================//
//========================== END USER CHUNKS MANIPULATION =========================//
//=================================================================================//

