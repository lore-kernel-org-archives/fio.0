Return-Path: <bruce@cran.org.uk>
Message-ID: <533E230D.8050301@cran.org.uk>
Date: Thu, 03 Apr 2014 21:12:13 -0600
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: ioengine=sync issue on Windows
References: <8a71414766f34cfe98805c5dd2e94d2e@DB4PR03MB572.eurprd03.prod.outlook.com> <53208C60.8090708@kernel.dk> <533B7FC4.70700@cran.org.uk> <533DE3DC.6020605@cran.org.uk> <533E1172.6010803@kernel.dk> <533E1590.1070109@cran.org.uk> <533E163B.2080605@kernel.dk> <533E1856.4080109@cran.org.uk> <533E1A5E.5070104@kernel.dk>
In-Reply-To: <533E1A5E.5070104@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, =?ISO-8859-1?Q?S=E9bastien_Bouchex_?= =?ISO-8859-1?Q?Bellomi=E9?= <sbouchex@infovista.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, bcran@fusionio.com
List-ID: <fio@vger.kernel.org>

On 4/3/2014 8:35 PM, Jens Axboe wrote:
> So next question... If you replace that fill_io_buffer() call with a 
> memset(b, 0, bs); does it then work?
>

The io error goes away, but now it occasionally crashes:

(gdb) bt

#0  0x64942e9e in pthread_mutex_unlock () from /cygdrive/c/Users/bcran/workspace/fio/libwinpthread-1.dll
#1  0x0043997c in run_threads () at backend.c:1791
#2  0x00439d9f in fio_backend () at backend.c:1904
#3  0x0044c274 in main (argc=2, argv=0x821728, envp=0x821988) at fio.c:50

(gdb) info threads
   Id   Target Id         Frame
   3    Thread 7256.0x4618 fio_pin_memory (td=td@entry=0x2820000) at memory.c:27
   2    Thread 7256.0xc8  0x7787bf3c in ?? ()
* 1    Thread 7256.0x5e04 0x64942e9e in pthread_mutex_unlock () from /cygdrive/c/Users/bcran/workspace/fio/libwinpthread-1.dll
(gdb) thread 3
(gdb) bt
#0  fio_pin_memory (td=td@entry=0x2820000) at memory.c:27
#1  0x00437076 in thread_main (data=0x2820000) at backend.c:1226
#2  0x64944ecb in pthread_create_wrapper () from /cygdrive/c/Users/bcran/workspace/fio/libwinpthread-1.dll
#3  0x752d0bc4 in wtoi64 () from /cygdrive/c/Windows/SysWOW64/msvcrt.dll
#4  0x752d0cec in msvcrt!_beginthreadex () from /cygdrive/c/Windows/SysWOW64/msvcrt.dll
#5  0x7699495d in KERNEL32!BaseThreadInitThunk () from /cygdrive/c/Windows/SysWOW64/KERNEL32.DLL
#6  0x778898ee in ?? ()
#7  0x778898c4 in ?? ()
#8  0x00000000 in ?? ()


-- 
Bruce

