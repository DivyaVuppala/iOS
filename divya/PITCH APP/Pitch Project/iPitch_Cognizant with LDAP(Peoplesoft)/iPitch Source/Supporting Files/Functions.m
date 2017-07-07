//
//  Functions.m
//  TruZign
//
//  Created by subashini MSK on 3/19/13.
//
//

#import "Functions.h"
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

@implementation Functions

static inline BOOL validate_methods(const char *,const char*) __attribute__((always_inline));
static inline void check_func(const char*,const char*)__attribute__((always_inline));
static inline int check_debugger() __attribute__((always_inline));
inline void disable_gdb () __attribute__((always_inline));
typedef int (*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);

#if !defined(PT_DENY_ATTACH)
#define PT_DENY_ATTACH 31
#endif  // !defined(PT_DENY_ATTACH)


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
        printf("These symbols are not the symbols you're looking for.Bailing.\n");
        exit(0);
    }
}


BOOL validate_methods(const char* cls,const char* fname)
{
    
    
    //printf("validate_methods");
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
    
    // printf("class_copyMethodList");
    //int count = nMethods -1;
    //  for(int i = nMethods-1;i <= 1 ;nMethods -- )
    //  {
    while(nMethods--)
    {
        
        if(nMethods  != 0)
        {
           // int methodcount = (int)nMethods;
            //printf("method %ud", methodcount);
            m = methods[nMethods];
//            printf("validating [%s %s]\n",
//                   (const char*) class_getName(aClass),
//                   (const char*) method_getName(m));
            imp = method_getImplementation(m);
            if(!imp)
            {
               // printf("error:method_getImplementation(%s) failed \n",
                       
                //       (const char*) method_getName(m));
                free(methods);
                return NO;
            }
            if(!dladdr(imp,&info))
            {
//                printf("error:dladdr() failed for %s\n",
//                       (const char*) method_getName(m));
                free (methods);
                return NO;
            }
            
            /* validate Image Path */
            
           // int i = strcmp(info.dli_fname,fname);
            // printf("strcmp %d %s %s",i,info.dli_fname,fname);
            if(strcmp(info.dli_fname,fname))
            {
               // printf("strcmp %d %s %s",i,info.dli_fname,fname);
                free(methods);
                return NO;
            }
            
            /*valdate Class name in symbol */
            snprintf(buf,sizeof(buf),"[%s",
                     (const char*) class_getName(aClass));
            
           // test(info.dli_sname+1);
            if(strncmp(info.dli_sname+1,buf,strlen(buf)))
            {
               // test(info.dli_sname+1);
               // snprintf(buf,sizeof(buf),"[%s(",(const char*) class_getName(aClass));
                if(strncmp(info.dli_sname+1,buf,strlen(buf)))
                {
                   // test(info.dli_sname+1);
                    free(methods);
                    return NO;
                }
            }
            
            /*validate selector in symbol */
            
            snprintf(buf,sizeof(buf),"%s]",(const char*)method_getName(m));
//            if(strncmp(info.dli_sname +(strlen(info.dli_sname) - strlen(buf)),buf,strlen(buf)))
//            {
//                test("Failes last");
//                free(methods);
//                return NO;
//                
//            }
        }
    }
    return YES;
    
}
int check_debugger()
{
    size_t size = sizeof(struct kinfo_proc);
    struct kinfo_proc info;
    int ret,name[4];
    memset(&info,0,sizeof(struct kinfo_proc));
    name[0] = CTL_KERN;
    name[1] = KERN_PROC;
    name[2] = KERN_PROC_PID;
    name[3] = getpid();
    if((ret =(sysctl(name,4,&info,&size,NULL,0))))
    {
        
        return ret; /*sysctl() failed */
    }
    
    return (info.kp_proc.p_flag & P_TRACED) ? 1:0;
}
int isJailBrokenFilesFound ()
{
    struct stat s;
    int is_jailbroken = NO;
    
    
    int iStat = stat("/Applications/Cydia.app",&s) ;
    if(iStat == 0)
    {
           is_jailbroken = YES;
        //is_jailbroken = NO; //For tetsing
    }
    
    //    if( stat("/Applications/Cydia.app",&s) == 0 || stat("/Library/MobileSubstrate/MobileSubstrate.dylib",&s) == 0 ||
    //        stat("/Library/MobileSubstrate/MobileSubstrate.dylib",&s) == 0 || stat("/var/cache/apt",&s) == 0 ||
    //        stat("/var/lib/apt",&s) == 0 || stat("/var/lib/cydia",&s) == 0 || stat("/var/log/syslog",&s) != 0 ||
    //        stat("/var/tmp/cydia.log",&s) == 0 || stat("/bin/sh",&s) == 0  ||
    //        stat("/usr/sbin/sshd",&s) == 0 || stat("/usr/libexec/ssh-keysign",&s) == 0 ||
    //        stat("/etc/ssh/sshd_config",&s) == 0 || stat("/etc/apt",&s) == 0
    //      )
    //    {
    //        //Invoke webservice to report tampering
    //
    //    }
    
    return is_jailbroken;
}
void disable_gdb ()
{
    void* handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
    ptrace_ptr_t ptrace_ptr = dlsym(handle, "ptrace");
    ptrace_ptr(PT_DENY_ATTACH, 0, 0, 0);
    dlclose(handle);
    
    printf("disbale");
}

+(void) method_1
{
    disable_gdb();
//    if(NO == validate_methods("NSURLConnection",/*"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator6.1.sdk/System/Library/Frameworks/Foundation.framework/Foundation"*/"/System/Library/Frameworks/Foundation.framework/Foundation"))
//    {
//        exit(0);
//    }
}

+(void) method_4
{
    disable_gdb();
}
+(int) method_5
{
    return  isJailBrokenFilesFound();
}
+(int) method_6
{
   int valueReturned= check_debugger();
    
    return valueReturned;
}

@end
