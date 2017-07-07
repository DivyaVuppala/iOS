
//
//  main.m
//  iPitch V2
//
//  Created by Satheeshwaran on 1/24/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <string.h>
#import <sys/stat.h>
#import <mach/mach_init.h>
#import <mach/vm_map.h>
#import <sys/types.h>
#import <dlfcn.h>
#import<objc/objc.h>
#import <objc/runtime.h>
#import "Functions.h"
#import "AppDelegate.h"
#import "ELCUIApplication.h"

typedef int (*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);
#if !defined(PT_DENY_ATTACH)
#define PT_DENY_ATTACH 31
#endif  // !defined(PT_DENY_ATTACH)


static inline int sandbox_integrity_compromised(void) __attribute__((always_inline));
static inline int check_debugger() __attribute__((always_inline));
static inline int isJailBrokenFilesFound() __attribute__((always_inline));
static inline void disable_gdb (void) __attribute__((always_inline));
static inline int rootFolderLinking() __attribute__((always_inline));
static inline int isKernelIntegrityCompromised() __attribute__((always_inline));
static inline BOOL validate_methods(const char *,const char*) __attribute__((always_inline));
static inline void check_func(const char*,const char*)__attribute__((always_inline));


void check_func(const char* cls,const char* sel)
{
    
    printf("check_func");
    Dl_info info;
    IMP imp = class_getMethodImplementation(objc_getClass(cls),
                                            sel_registerName(sel));
    
    printf("pointer %p\n",imp);
    if(dladdr(imp,&info))
    {
        printf("dli_fname:%s\n",info.dli_fname);
        printf("dli_sname:%s\n",info.dli_sname);
        printf("dli_fbase:%s\n",info.dli_fbase);
        printf("dli_saddr:%s\n",info.dli_saddr);
        int  i = strcmp(info.dli_fname,"/System/Library/Frameworks/Foundation.framework/Foundation");
        int j = strncmp(info.dli_sname,"-[NSURLConnection init",22);
        
        printf("%d %d",i,j);
        if(strcmp(info.dli_fname,"/System/Library/Frameworks/Foundation.framework/Foundation")||strncmp(info.dli_sname,"-[NSURLConnection init",22))
        {
            
            printf("Danger:\n");
            exit(0);
        }
        
    }
    else{
        printf("These symbols are not the symbols you're lokking for.Bailing.\n");
        exit(0);
    }
}

void test1(int i)
{
}

void test2(const char* one ,const char* two)
{
}
// BOOL validate_methods(const char* cls,const char* fname)
//{
//    test1(0);
//    printf("validate_methods");
//    Class aClass = objc_getClass(cls);
//    Method* methods;
//    unsigned int nMethods;
//    Dl_info info;
//    IMP imp;
//    char buf[128];
//    Method m;
//     test1(1);
//    if(!aClass)
//        return NO;
//    methods = class_copyMethodList(aClass,&nMethods);
//     test1(2);
//    //printf("class_copyMethodList");
//    //int count = nMethods -1;
//    //  for(int i = nMethods-1;i <= 1 ;nMethods -- )
//    //  {
//    while(nMethods--)
//    {
//
//        if(nMethods  != 0)
//        {
//            int methodcount = (int)nMethods;
//            printf("method %ud", methodcount);
//            m = methods[nMethods];
//            //printf("validating [%s %s]\n",
//                   //(const char*) class_getName(aClass),
//                  // (const char*) method_getName(m));
//             test1(3);
//            imp = method_getImplementation(m);
//
//            if(!imp)
//            {
////                printf("error:method_getImplementation(%s) failed \n",
////
////                       (const char*) method_getName(m));
//                test1(4);
//                free(methods);
//                return NO;
//            }
//            if(!dladdr(imp,&info))
//            {
////                printf("error:dladdr() failed for %s\n",
////                       (const char*) method_getName(m));
////                free (methods);
//                 test1(5);
//                return NO;
//            }
//
//            /* validate Image Path */
//
//           // int i = strcmp(info.dli_fname,fname);
//
//           // test1(i);
//            //test2(info.dli_fname,fname);
//             //printf("strcmp %d %s %s",i,info.dli_fname,fname);
//            if(strcmp(info.dli_fname,fname))
//            {
//               // printf("strcmp %d %s %s",i,info.dli_fname,fname);
//               //  test1(6);
//
//
//                free(methods);
//                return NO;
//            }
//
//            /*valdate Class name in symbol */
//           // snprintf(buf,sizeof(buf),"[%s",
//              //       (const char*) class_getName(aClass));
//            if(strncmp(info.dli_sname+1,buf,strlen(buf)))
//            {
//                snprintf(buf,sizeof(buf),"[%s(",(const char*) class_getName(aClass));
//                 test1(7);
//                if(strncmp(info.dli_sname+1,buf,strlen(buf)))
//                {
//                    test1(8);
//                    free(methods);
//                    return NO;
//                }
//            }
//
//            /*validate selector in symbol */
//
//            //snprintf(buf,sizeof(buf),"%s]",(const char*)method_getName(m));
//             test1(9);
//            if(strncmp(info.dli_sname +(strlen(info.dli_sname) - strlen(buf)),buf,strlen(buf)))
//            {
//                free(methods);
//                return NO;
//
//            }
//        }
//    }
//    return YES;
//
//}

BOOL validate_methods(const char* cls,const char* fname)
{
    
    printf("validate_methods");
    Class aClass = objc_getClass(cls);
    Method* methods;
    unsigned int nMethods;
    Dl_info info;
    IMP imp;
    char buf[128];
    Method m;
    
    if(!aClass)
        return NO;
    methods = class_copyMethodList(aClass,&nMethods);
    
    //printf("class_copyMethodList");
    //int count = nMethods -1;
    //  for(int i = nMethods-1;i <= 1 ;nMethods -- )
    //  {
    while(nMethods--)
    {
        
        if(nMethods  != 0)
        {
            //  printf("method %ud", methodcount);
            m = methods[nMethods];
            //            printf("validating [%s %s]\n",
            //                   (const char*) class_getName(aClass),
            //                   (const char*) method_getName(m));
            imp = method_getImplementation(m);
            if(!imp)
            {
                printf("error:method_getImplementation(%s) failed \n",
                       
                       (const char*) method_getName(m));
                free(methods);
                return NO;
            }
            if(!dladdr(imp,&info))
            {
                printf("error:dladdr() failed for %s\n",
                       (const char*) method_getName(m));
                free (methods);
                return NO;
            }
            
            /* validate Image Path */
            
            int i = strcmp(info.dli_fname,fname);
            
            test2(info.dli_fname,"fanem");
            // printf("strcmp %d %s %s",i,info.dli_fname,fname);
            if(strcmp(info.dli_fname,fname))
            {
                printf("strcmp %d %s %s",i,info.dli_fname,fname);
                free(methods);
                return NO;
            }
            
            /*valdate Class name in symbol */
            snprintf(buf,sizeof(buf),"[%s",
                     (const char*) class_getName(aClass));
            
            test2(info.dli_sname,"sname");
            test1(strlen(buf));
            if(strncmp(info.dli_sname+1,buf,strlen(buf)))
            {
                // test2(info.dli_sname+1,"df");
                // snprintf(buf,sizeof(buf),"[%s(",(const char*) class_getName(aClass));
                
                //  test2(info.dli_sname+1,"df");
                // test1(strlen(buf));
                if(strncmp(info.dli_sname+1,buf,strlen(buf)))
                {
                    test1(8);
                    free(methods);
                    return NO;
                }
            }
            
            /*validate selector in symbol */
            
            snprintf(buf,sizeof(buf),"%s]",(const char*)method_getName(m));
            if(strncmp(info.dli_sname +(strlen(info.dli_sname) - strlen(buf)),buf,strlen(buf)))
            {
                free(methods);
                return NO;
                
            }
        }
    }
    return YES;
    
}
int sandbox_integrity_compromised(void)
{
    int result=fork(); //Perform the fork
    if(!result)//the child should exit if it is spawned
        //exit(0);
    if(result>=0) //If the Fork Succeeded we are Jail broken.
        return 1;
    return 0;
}

inline int isJailBrokenFilesFound ()
{
    struct stat s;
    int is_jailbroken = NO;
    
    
    int iStat = stat("/Applications/Cydia.app",&s) ;
    if(iStat == 0)
    {
        
        // NSLog(@"*******************************JAILE BROKEN11111111");
        is_jailbroken = YES;
        //is_jailbroken = NO;
    }
    
//    if( stat("/Applications/Cydia.app",&s) == 0 || stat("/Library/MobileSubstrate/MobileSubstrate.dylib",&s) == 0 ||
//       stat("/Library/MobileSubstrate/MobileSubstrate.dylib",&s) == 0 || stat("/var/cache/apt",&s) == 0 ||
//       stat("/var/lib/apt",&s) == 0 || stat("/var/lib/cydia",&s) == 0 || stat("/var/log/syslog",&s) == 0 ||
//       stat("/var/tmp/cydia.log",&s) == 0 || stat("/bin/sh",&s) == 0  ||
//       stat("/usr/sbin/sshd",&s) == 0 || stat("/usr/libexec/ssh-keysign",&s) == 0 ||
//       stat("/etc/ssh/sshd_config",&s) == 0 || stat("/etc/apt",&s) == 0
//       )
//    {
//        
//        // NSLog(@"*******************************JAILE BROKEN2222222");
//        is_jailbroken = YES;
//        //Invoke webservice to report tampering
//        
//    }
    
    return is_jailbroken;
}

inline int rootFolderLinking()
{
    struct stat s;
    if (lstat("/Applications", &s)!=0) {
        if (s.st_mode & S_IFLNK) {
            return 1;
        }
        
    }
    return 0;
}


inline void disable_gdb (void)
{
    void* handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
    ptrace_ptr_t ptrace_ptr = dlsym(handle, "ptrace");
    ptrace_ptr(PT_DENY_ATTACH, 0, 0, 0);
    dlclose(handle);
    
}


inline int isKernelIntegrityCompromised()
{
    void *mem=malloc(getpagesize()+15);
    void *ptr=(void*)(((uintptr_t)mem+15)& ~ 0x0F);
    vm_address_t pagePtr=(uintptr_t)ptr/getpagesize() * getpagesize();
    
    int isCompromised=vm_protect(mach_task_self(), (vm_address_t)pagePtr, getpagesize(), FALSE, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_EXECUTE)==0;
    free(mem);
    return isCompromised;
    
}


int main(int argc, char *argv[])
{
    
    if(isJailBrokenFilesFound() || sandbox_integrity_compromised() /*|| isKernelIntegrityCompromised()*/)
    {
        exit(0);
    }
    
    
    /*  else if(rootFolderLinking())
    {
        //Report Tampering
        exit(-1);
    }*/
    
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv,NSStringFromClass([ELCUIApplication class]) ,NSStringFromClass([AppDelegate class]));
    }

}
