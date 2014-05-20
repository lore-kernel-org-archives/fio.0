Return-Path: <axboe@kernel.dk>
Message-ID: <537AB6F3.9030303@kernel.dk>
Date: Mon, 19 May 2014 19:59:15 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Fix a bug of rbd engine when specify invalidate=1 or fadvise_hint=1
References: <CA+8ZFngfLhzUopzPznyQ-ZwZgqMuDiEPhUpK5c20HkWNe0nz6w@mail.gmail.com>	<537A5CFE.4090800@kernel.dk> <CA+8ZFng-kGsBJJqNH+ze9TCjpkAMpxTUUeh97U1NKSiFX9K6EQ@mail.gmail.com>
In-Reply-To: <CA+8ZFng-kGsBJJqNH+ze9TCjpkAMpxTUUeh97U1NKSiFX9K6EQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: "xan.peng" <xanpeng@gmail.com>
Cc: daniel.gollub@gmail.com, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-05-19 19:32, xan.peng wrote:
> Sure, it's better to have a new type.
> the pull request (https://github.com/axboe/fio/pull/11) is updated in
> the following way:

So thinking more about it, I think it would be a lot cleaner to simply 
add an ->invalidate() IO ops hook instead. This retains that this is a 
file, special sort of loses that. And it mirrors what we do in other 
places, like the very open that rbd hooks in as well.

Committed this:

http://git.kernel.dk/?p=fio.git;a=commit;h=d9b100fc117a963334fb71b8b662be90cd456068

-- 
Jens Axboe


