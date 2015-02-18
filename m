Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <54E4DBB7.7080705@kernel.dk>
References: <54E35788.2000400@enovance.com> <54E4DBB7.7080705@kernel.dk>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Wed, 18 Feb 2015 23:54:43 +0400
Message-ID: <CANvN+en=Ln6fAVoAxw2sg7_nFxXcCn2VT4kzumYi5W7gkn+_5Q@mail.gmail.com>
Subject: Re: Potential leaks & errors on current trunk
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Erwan Velu <erwan@enovance.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On a related issue, valgrind reports a couple of leaks of strdup'ed
memory. May be a bogus, as the code inspection shows respective free()
calls in place, but just in case.

Regards,
Andrey

==3639== HEAP SUMMARY:
==3639==     in use at exit: 241 bytes in 7 blocks
==3639==   total heap usage: 452 allocs, 445 frees, 2,238,768 bytes allocated
==3639==
==3639== 5 bytes in 1 blocks are definitely lost in loss record 4 of 7
==3639==    at 0x4C2AB80: malloc (in
/usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==3639==    by 0x5E163C9: strdup (strdup.c:42)
==3639==    by 0x43055D: __handle_option (parse.c:662)
==3639==    by 0x431087: handle_option (parse.c:885)
==3639==    by 0x431EB3: fill_default_options (parse.c:1200)
==3639==    by 0x41363F: fio_init_options (init.c:1679)
==3639==    by 0x41369C: parse_options (init.c:2370)
==3639==    by 0x40B8CC: main (fio.c:40)
==3639==
==3639== 8 bytes in 1 blocks are definitely lost in loss record 6 of 7
==3639==    at 0x4C2AB80: malloc (in
/usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==3639==    by 0x5E163C9: strdup (strdup.c:42)
==3639==    by 0x4355FD: fio_options_mem_dupe (options.c:4050)
==3639==    by 0x40EB08: get_new_job (init.c:413)
==3639==    by 0x4130DB: parse_cmd_line (init.c:2128)
==3639==    by 0x4136E5: parse_options (init.c:2375)
==3639==    by 0x40B8CC: main (fio.c:40)
==3639==
==3639== LEAK SUMMARY:
==3639==    definitely lost: 13 bytes in 2 blocks
==3639==    indirectly lost: 0 bytes in 0 blocks
==3639==      possibly lost: 0 bytes in 0 blocks
==3639==    still reachable: 228 bytes in 5 blocks
==3639==         suppressed: 0 bytes in 0 blocks
==3639== Reachable blocks (those to which a pointer was found) are not shown.
==3639== To see them, rerun with: --leak-check=full --show-leak-kinds=all
==3639==
==3639== For counts of detected and suppressed errors, rerun with: -v
==3639== ERROR SUMMARY: 2 errors from 2 contexts (suppressed: 0 from 0)
Regards,
Andrey


On Wed, Feb 18, 2015 at 9:36 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 02/17/2015 07:00 AM, Erwan Velu wrote:
>>
>> I've been playing with clang 3.3 on
>> 495288a1e627c3d1b29897786b786eb6008841a3 and found the following items
>> interesting.
>>
>> Before making any PR, I'd like your insights on them.
>>
>>
>> http://git.kernel.dk/?p=fio.git;a=blob;f=filesetup.c;h=0fb5589b7c33ce1aa154c21ecf42cf52a682c4d8;hb=HEAD#l424
>>
>> On that part of the code, it's not clear for me if we want to return ret
>> or always 0.
>> So we have to remove ret=0 _or_ change to return ret;
>> As some code is considering that __file_invalidate_cache can be
>> different from 0, I think it's the latter case.
>
>
> We always want to return 0 here, as it's not a fatal error.
>
>>
>> http://git.kernel.dk/?p=fio.git;a=blob;f=client.c;h=760ec85087b73bba197c95b033154f08c245bc7f;hb=HEAD#l1572
>>
>> We have an issue on this dprint as it use eta that I've been freed in
>> fio_client_dec_jobs_eta().
>> So using dprint could lead to a very weird message print here.
>> Shall we keep that dprint which could be buggy ? If we still want it,
>> that would mean put extra variable to save the required info for
>> printing it.
>
>
> It's printing the pointer value, not the contents. So that's always valid.
> It's just for debug tracking if you want to see eta's go through.
>
>>
>> http://git.kernel.dk/?p=fio.git;a=blob;f=iolog.c;h=99f8bc18d8694cca0c141c51d116aced1b4130f2;hb=HEAD#l863
>>
>> In that function, if we do return 1 we do leak ic.buf, we shall free it
>> before the return
>
>
> Yep, there's a potential leak or two there, should be fixed up.
>
>>
>> http://git.kernel.dk/?p=fio.git;a=blob;f=lib/axmap.c;h=164300f254014b10ed6e04e3e06b7263aa917aac;hb=HEAD#l127
>>
>> Here, we surely miss the free of the axmap. We did free its internal
>> structure but not axmap itself.
>
>
> Yes, that should free 'axmap' too of course.
>
> --
> Jens Axboe
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

