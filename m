Return-Path: <axboe@kernel.dk>
Message-ID: <54E4F5D2.2060008@kernel.dk>
Date: Wed, 18 Feb 2015 12:28:02 -0800
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Potential leaks & errors on current trunk
References: <54E35788.2000400@enovance.com> <54E4DBB7.7080705@kernel.dk> <CANvN+en=Ln6fAVoAxw2sg7_nFxXcCn2VT4kzumYi5W7gkn+_5Q@mail.gmail.com>
In-Reply-To: <CANvN+en=Ln6fAVoAxw2sg7_nFxXcCn2VT4kzumYi5W7gkn+_5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: Erwan Velu <erwan@enovance.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 02/18/2015 11:54 AM, Andrey Kuzmin wrote:
> On a related issue, valgrind reports a couple of leaks of strdup'ed
> memory. May be a bogus, as the code inspection shows respective free()
> calls in place, but just in case.
>
> Regards,
> Andrey
>
> ==3639== HEAP SUMMARY:
> ==3639==     in use at exit: 241 bytes in 7 blocks
> ==3639==   total heap usage: 452 allocs, 445 frees, 2,238,768 bytes allocated
> ==3639==
> ==3639== 5 bytes in 1 blocks are definitely lost in loss record 4 of 7
> ==3639==    at 0x4C2AB80: malloc (in
> /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
> ==3639==    by 0x5E163C9: strdup (strdup.c:42)
> ==3639==    by 0x43055D: __handle_option (parse.c:662)
> ==3639==    by 0x431087: handle_option (parse.c:885)
> ==3639==    by 0x431EB3: fill_default_options (parse.c:1200)
> ==3639==    by 0x41363F: fio_init_options (init.c:1679)
> ==3639==    by 0x41369C: parse_options (init.c:2370)
> ==3639==    by 0x40B8CC: main (fio.c:40)
> ==3639==
> ==3639== 8 bytes in 1 blocks are definitely lost in loss record 6 of 7
> ==3639==    at 0x4C2AB80: malloc (in
> /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
> ==3639==    by 0x5E163C9: strdup (strdup.c:42)
> ==3639==    by 0x4355FD: fio_options_mem_dupe (options.c:4050)
> ==3639==    by 0x40EB08: get_new_job (init.c:413)
> ==3639==    by 0x4130DB: parse_cmd_line (init.c:2128)
> ==3639==    by 0x4136E5: parse_options (init.c:2375)
> ==3639==    by 0x40B8CC: main (fio.c:40)
> ==3639==
> ==3639== LEAK SUMMARY:
> ==3639==    definitely lost: 13 bytes in 2 blocks
> ==3639==    indirectly lost: 0 bytes in 0 blocks
> ==3639==      possibly lost: 0 bytes in 0 blocks
> ==3639==    still reachable: 228 bytes in 5 blocks
> ==3639==         suppressed: 0 bytes in 0 blocks
> ==3639== Reachable blocks (those to which a pointer was found) are not shown.
> ==3639== To see them, rerun with: --leak-check=full --show-leak-kinds=all
> ==3639==
> ==3639== For counts of detected and suppressed errors, rerun with: -v
> ==3639== ERROR SUMMARY: 2 errors from 2 contexts (suppressed: 0 from 0)

I'm sure there are a few leaks. Usually it doesn't matter as fio exits, 
but the ones that are valid leaks that hit the client/server backend, 
those generally do want to get fixed up. It's a shame to have the fio 
backend server leak memory, since it could potentially sit around for a 
long time.

-- 
Jens Axboe


