Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Sat, 8 May 2021 19:18:23 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] don't access dlclose'd dynamic ioengine object after
 close
Message-ID: <YJa5zyE1UhdNHkzd@localhost.localdomain>
References: <14499187-1da8-ff0c-6b60-8fa6dd33d9fa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <14499187-1da8-ff0c-6b60-8fa6dd33d9fa@redhat.com>
To: Eric Sandeen <esandeen@redhat.com>
Cc: fio <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On Fri, May 07, 2021 at 04:13:05PM -0500, Eric Sandeen wrote:
> Alexey reported this bug when using dynamically loaded IO engines;
> a segfault on the line where we set the dlhandle to NULL after
> the dlclose.
> 
> I think this is because ops points to the thing we obtained from dlsym:
> 
> 	ops = dlsym(dlhandle, engine_lib);
> 
> and after the final dlclose, the object no longer exists and efforts
> to set the handle within it will fail for obvious reasons.
> I'm not sure why I hadn't seen this before.
> 
> Fixes-RH-Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1956963
> Reported-by: Alexey Dobriyan <adobriyan@gmail.com>
> Fixes: f6931a1 ("fio: move dynamic library handle to io_ops structure")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Please, somebody who is better than I am at this review it to see
> if I'm just causing more problems.  ;)
> 

> --- a/ioengines.c
> +++ b/ioengines.c
> @@ -234,7 +234,6 @@ void free_ioengine(struct thread_data *td)
>  	if (td->io_ops->dlhandle) {
>  		dprint(FD_IO, "dlclose ioengine %s\n", td->io_ops->name);
>  		dlclose(td->io_ops->dlhandle);
> -		td->io_ops->dlhandle = NULL;
>  	}
>  
>  	td->io_ops = NULL;

I tested by rebuilding 3.26-1.fc34 with just this patch.
It seems to work.

	Tested-by: Alexey Dobriyan <adobriyan@gmail.com>


As for review, valgrind reports a leak but it reports similar looking
leak with ioengine=psync as well, so...

==5564==
==5564== HEAP SUMMARY:
==5564==     in use at exit: 356 bytes in 26 blocks
==5564==   total heap usage: 1,870 allocs, 1,844 frees, 20,598,032 bytes allocated
==5564==
==5564== LEAK SUMMARY:
==5564==    definitely lost: 43 bytes in 3 blocks
==5564==    indirectly lost: 48 bytes in 5 blocks
==5564==      possibly lost: 0 bytes in 0 blocks
==5564==    still reachable: 265 bytes in 18 blocks
==5564==         suppressed: 0 bytes in 0 blocks
==5564== Rerun with --leak-check=full to see details of leaked memory
==5564==
==5564== For lists of detected and suppressed errors, rerun with: -s
==5564== ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 0 from 0)

