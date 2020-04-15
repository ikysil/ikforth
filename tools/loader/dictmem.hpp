#ifndef _dictmem_
#define _dictmem_

// idea shamelessly borrowed from
// http://blog.nervus.org/managing-virtual-address-spaces-with-mmap/

void * AllocateDictionaryAddressSpace(void * addr, size_t size);

void * CommitDictionaryMemory(void * addr, size_t size);

void DecommitDictionaryMemory(void * addr, size_t size);

void FreeDictionaryAddressSpace(void * addr, size_t size);

#endif
