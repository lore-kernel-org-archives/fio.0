Return-Path: <axboe@kernel.dk>
Message-ID: <54E4DBB7.7080705@kernel.dk>
Date: Wed, 18 Feb 2015 10:36:39 -0800
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Potential leaks & errors on current trunk
References: <54E35788.2000400@enovance.com>
In-Reply-To: <54E35788.2000400@enovance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Erwan Velu <erwan@enovance.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 02/17/2015 07:00 AM, Erwan Velu wrote:
> I've been playing with clang 3.3 on
> 495288a1e627c3d1b29897786b786eb6008841a3 and found the following items
> interesting.
>
> Before making any PR, I'd like your insights on them.
>
> http://git.kernel.dk/?p=fio.git;a=blob;f=filesetup.c;h=0fb5589b7c33ce1aa154c21ecf42cf52a682c4d8;hb=HEAD#l424
>
> On that part of the code, it's not clear for me if we want to return ret
> or always 0.
> So we have to remove ret=0 _or_ change to return ret;
> As some code is considering that __file_invalidate_cache can be
> different from 0, I think it's the latter case.

We always want to return 0 here, as it's not a fatal error.

> http://git.kernel.dk/?p=fio.git;a=blob;f=client.c;h=760ec85087b73bba197c95b033154f08c245bc7f;hb=HEAD#l1572
>
> We have an issue on this dprint as it use eta that I've been freed in
> fio_client_dec_jobs_eta().
> So using dprint could lead to a very weird message print here.
> Shall we keep that dprint which could be buggy ? If we still want it,
> that would mean put extra variable to save the required info for
> printing it.

It's printing the pointer value, not the contents. So that's always 
valid. It's just for debug tracking if you want to see eta's go through.

> http://git.kernel.dk/?p=fio.git;a=blob;f=iolog.c;h=99f8bc18d8694cca0c141c51d116aced1b4130f2;hb=HEAD#l863
>
> In that function, if we do return 1 we do leak ic.buf, we shall free it
> before the return

Yep, there's a potential leak or two there, should be fixed up.

> http://git.kernel.dk/?p=fio.git;a=blob;f=lib/axmap.c;h=164300f254014b10ed6e04e3e06b7263aa917aac;hb=HEAD#l127
>
> Here, we surely miss the free of the axmap. We did free its internal
> structure but not axmap itself.

Yes, that should free 'axmap' too of course.

-- 
Jens Axboe


