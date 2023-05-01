#include <inc/assert.h>
#include <inc/string.h>
#include "../inc/dynamic_allocator.h"


//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
	cprintf("\n=========================================\n");

}

//****//
//****//

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
	}


//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){

		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
}
//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}



//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
        if (pointertempp->size > size){
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
            struct MemBlock *newBlock = ptrnew;
             newBlock->size = size;
             newBlock->sva = pointertempp->sva ;
              pointertempp->size = pointertempp->size - size;
              pointertempp->sva =pointertempp->sva + size ;
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
                    return newBlock ;
                    }
        else if (pointertempp->size == size){
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
}


//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
		if (elementiterator->size >= size){
			uint32 differance = elementiterator->size - size ;
			if (differance < differsize){
				differsize = differance ;
				pointer2 = elementiterator ;
				if (differsize == 0){
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
					return elementiterator;
				}
			}
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
		blockToUpdate->size = size ;
		blockToUpdate->sva = pointer2->sva;
		pointer2->size = pointer2->size -size;
		pointer2->sva = pointer2->sva + size ;
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
		return blockToUpdate;
	}

	return NULL;
}
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
	        if (updated->size > size){
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
	            struct MemBlock *newBlock = ptrnew;
	             newBlock->size = size;
	             newBlock->sva =updated->sva ;
	              updated->size = updated->size - size;
	              updated->sva =updated->sva + size ;
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
	                    return newBlock ;
	                    }
	        else if (updated->size == size){
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
	}

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
		&& lastptr->prev_next_info.le_next==NULL
		&&size_of_free!=0 ){
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
		&& ptr->prev_next_info.le_prev==NULL
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);

		         break;
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
				&&FreeMemBlocksList.lh_last !=NULL
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
		blockToInsert->size =0;
		blockToInsert->sva =0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
		blockToInsert->size=0;
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
			== ptr->sva && ptr!=NULL
			&&ptr->prev_next_info.le_prev==NULL)
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
		blockToInsert->size=0;
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva

			){


		ptr->sva=blockToInsert->sva;
		ptr->size=ptr->size + blockToInsert->size ;
		blockToInsert->size=0;
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;//8
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
			&&ptr!=NULL)
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
	    blockToInsert->sva = 0;
	    blockToInsert->size = 0;
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
	    ptr->prev_next_info.le_next->sva = 0;
	    ptr->prev_next_info.le_next->size = 0;
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);

	    break;//9
	}




	}
	}
	}
