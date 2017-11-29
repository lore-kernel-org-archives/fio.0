Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:18821 "EHLO muon.bluestop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751395AbdK2Eom (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 28 Nov 2017 23:44:42 -0500
Content-Type: text/plain; charset="utf-8"
Mime-Version: 1.0 (1.0)
Subject: Re: fio 3.2
From: Rebecca Cran <rebecca@bluestop.org>
In-Reply-To: <AT5PR8401MB03875F6DB61311D1D8B40419AB3B0@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
Date: Tue, 28 Nov 2017 21:44:39 -0700
Content-Transfer-Encoding: 8bit
Message-Id: <B51AE08B-A0D4-457B-8DF5-E1CD3DC2A271@bluestop.org>
References: <TU4PR8401MB099112614914A9232A07490DEC270@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM> <903d418b-bac4-104b-28e5-3c529efab7f5@kernel.dk> <TU4PR8401MB0991DC48F1741A8F8F1DEF20EC240@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM> <CALjAwxh9bP38Uqsy=OmxqZKRxpKYEArYuT1RYC76jL6oqF3daQ@mail.gmail.com> <TU4PR8401MB099189C195BE973BED0D0C15EC250@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM> <CALjAwxiQU=C4ye2gN4-9S6D75f3HQ7q7w2TpE0O+fH6C+MXLHg@mail.gmail.com> <b9bce0b0-9683-59b6-4c08-62f29d80935a@bluestop.org> <TU4PR8401MB0991F4C4CAD9858A3BF2AE9DEC3A0@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM> <AT5PR8401MB0387489EC42684D7FACF3E1EAB3A0@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM> <TU4PR8401MB0991EBEF27D16271CD5361AAEC3B0@TU4PR8401MB0991.NAMPRD84.PROD.OUTLOOK.COM> <AT5PR8401MB03875F6DB61311D1D8B40419AB3B0@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: "Gavriliuk, Anton (HPS Ukraine)" <anton.gavriliuk@hpe.com>, Sitsofe Wheeler <sitsofe@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "Kani, Toshimitsu" <toshi.kani@hpe.com>

I’ve not followed the whole discussion, but I did some tests a couple of months ago replacing the calls to memcpy in the memmap engine with a new fio_memcpy function, rebuilding fio with the -ftree-vectorize flag along with -msse2, -mavx etc. 
I saw an improvement of a few hundred MB/sec on my openSUSE system.

— 
Rebecca 

Sent from my iPhone

> On Nov 28, 2017, at 9:13 PM, Elliott, Robert (Persistent Memory) <elliott@hpe.com> wrote:
> 
> 
>> -----Original Message-----
>> From: Gavriliuk, Anton (HPS Ukraine)
>> Sent: Tuesday, November 28, 2017 9:35 PM
>> To: Elliott, Robert (Persistent Memory) <elliott@hpe.com>; Rebecca Cran
>> <rebecca@bluestop.org>; Sitsofe Wheeler <sitsofe@gmail.com>
>> Cc: fio@vger.kernel.org; Kani, Toshimitsu <toshi.kani@hpe.com>
>> Subject: RE: fio 3.2
> 
> 
>> 4. The CPU instructions used by fio depend on the glibc library version.
>> As mentioned in an earlier fio thread, that changes a lot. With
>> libc2.24.so, random reads seem to be done with rep movsb.
>> 
>> The test box SLES12 SP3 has glibc2.22, so we have to update. But I can't
>> understand what does it mean - " random reads seem to be done with rep
>> movsb "
> 
> While the test is running, run
>    perf top
> 
> and select one of the busiest functions (hopefully a memcpy function):
> 
>  90.14%  libc-2.24.so         [.] __memmove_avx_unaligned_erms
>   3.85%  [unknown]            [k] 0x00007f7414f5c4ff
>   0.53%  [kernel]             [k] wait_consider_task
>   0.33%  fio                  [.] get_io_u
>   0.29%  fio                  [.] td_io_queue
>   0.26%  fio                  [.] io_u_sync_complete
> 
> Hit enter twice to get to the assembly language code.  This shows you
> the amount of time the CPUs are spending in each instruction (based on
> sampling):
> 
>  0.03 â”‚ 2b:   cmp    __x86_shared_non_temporal_threshold,%rdx
>  0.01 â”‚     â†“ jae    15d
>       â”‚       cmp    %rsi,%rdi
>  0.00 â”‚     â†“ jb     4c
>       â”‚     â†“ je     51
>       â”‚       lea    (%rsi,%rdx,1),%r9
>       â”‚       cmp    %r9,%rdi
>       â”‚     â†“ jb     211
>       â”‚ 4c:   mov    %rdx,%rcx
> 99.88 â”‚       rep    movsb %ds:(%rsi),%es:(%rdi)
>  0.08 â”‚ 51: â† retq
>       â”‚ 52:   cmp    $0x10,%dl
> 
> That means 99.88% of 90.14% of the time is spend on rep movsb, presumably
> reading from persistent memory (and writing to regular memory, but to
> a buffer that's entirely in the CPU caches).
> 
> Some more examples of how to analyze the results:
> 
> If I remove the norandommap option, fio spends about 1% of the CPU time 
> in a function maintaining the list of which LBAs it has read:
>  89.63%  libc-2.24.so                [.] __memmove_avx_unaligned_erms
>   3.28%  [unknown]                   [k] 0x00007f34da4824ff
>   0.87%  fio                         [.] axmap_isset 
>   0.58%  [kernel]                    [k] wait_consider_task
>   0.38%  fio                         [.] get_io_u
>   0.34%  fio                         [.] io_u_sync_complete
> 
> 
> If I switch to random writes and remove the zerobuffers option, fio spends
> about 7% of the CPU time creating non-zero write data (to then write
> into persistent memory):
>  79.04%  libc-2.24.so        [.] __memmove_avx_unaligned_erms
>   6.98%  fio                 [.] get_io_u
>   4.24%  [unknown]           [k] 0x00007f8ee86d34ff
>   0.85%  fio                 [.] io_queue_event
>   0.82%  fio                 [.] axmap_isset
>   0.62%  fio                 [.] io_u_sync_complete
>   0.62%  [kernel]            [k] wait_consider_task
>   0.58%  fio                 [.] td_io_queue
>   0.45%  fio                 [.] thread_main
> 
> get_io_u calls small_content_scramble which calls memcpy for 8
> bytes at a time.  On my system, gcc chose to inline memcpy
> rather than call the glibc library version, and it ends up just
> using regular mov instructions:
> 
>       â”‚      memcpy():
>       â”‚
>       â”‚      __fortify_function void *
>       â”‚      __NTH (memcpy (void *__restrict __dest, const void *__restrict __src,
>       â”‚                     size_t __len))
>       â”‚      {
>       â”‚        return __builtin___memcpy_chk (__dest, __src, __len, __bos0 (__dest));
> 32.56 â”‚        mov    %rax,-0x200(%rcx,%rsi,1)
>  5.18 â”‚        mov    0x0(%rbp),%rsi
>       â”‚      small_content_scramble():
>       â”‚                              get_verify = 1;
>  2.49 â”‚        add    $0x200,%rax
>  2.81 â”‚        mov    0x8(%rbp),%rdi
>       â”‚      memcpy():
> 32.91 â”‚        mov    %rsi,-0x10(%rcx)
>  3.45 â”‚        mov    %rdi,-0x8(%rcx)
>       â”‚      small_content_scramble():
>       â”‚                                      td->trim_batch = td->o.trim_backlog;
>       â”‚                              get_trim = 1;
>       â”‚                      }
>       â”‚
>       â”‚                      if (get_trim && get_next_trim(td, io_u))
>       â”‚                              return true;
> 
> small_content_scramble has hardly been touched since 2011, so it probably
> hasn't had much performance analysis.  
> 
> One of the few changes made was to add an integer divide by 1000, which 
> is always slow (painfully slow on some CPUs):
> 
>    offset = ((io_u->start_time.tv_nsec/1000) ^ boffset) & 511;
> 
> perf top doesn't show that taking time - I think the compiler realized
> it could pull that calculation out of the loop and just do it once.  Different
> compilers and compiler options might not realize that.
> 
> 
> èº{.nÇ+‰·Ÿ®‰­†+%ŠËlzwm…ébë§²æìr¸›yø¨Š{ayºÊ‡Ú™ë,j­¢f£¢·hš‹àz¹®w¥¢¸¢·¦j:+v‰¨ŠwèjØm¶Ÿÿ¾«‘êçzZ+ƒùšŽŠÝ¢j"ú!¶i

