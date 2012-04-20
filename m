Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58858 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab2DTQWW convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 20 Apr 2012 12:22:22 -0400
Received: by vcqp1 with SMTP id p1so6507039vcq.19
        for <fio@vger.kernel.org>; Fri, 20 Apr 2012 09:22:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F917240.6030003@kernel.dk>
References: <0FEAAA2D70C89D49A62173478A6C4A5D02DECC2A@XYUS-EX22.xyus.xyratex.com>
 <4F8E6BFD.10408@kernel.dk> <0FEAAA2D70C89D49A62173478A6C4A5D02DECCB6@XYUS-EX22.xyus.xyratex.com>
 <4F8F0A62.80101@kernel.dk> <0FEAAA2D70C89D49A62173478A6C4A5D02DECCD7@XYUS-EX22.xyus.xyratex.com>
 <4F9104F9.2060308@kernel.dk> <0FEAAA2D70C89D49A62173478A6C4A5D02DECDC6@XYUS-EX22.xyus.xyratex.com>
 <4F917240.6030003@kernel.dk>
From: Steven Lang <tirea@google.com>
Date: Fri, 20 Apr 2012 09:22:00 -0700
Message-ID: <CAAUT-yMY-xK8HRYdN7Fe8KOuqqt2LyDp7OAX43-mikpU055rhQ@mail.gmail.com>
Subject: Re: segfault runninng fio against 2048 jobs
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

It seems like a lot of what is in the thread_data structure does not
need to be in shared memory; the configuration information is static
(And in fact some of it is just pointers into process memory) and much
of it is just used for the running job, such as anything referencing
files or io_u.  If instead of the whole structure, just necessarily
shared parts were put in the shared segment, even OSs with limited
shared segment sizes could better make use of shared memory and run
more jobs.

Not to mention that any job which runs in a thread rather than a
process doesn't need to be in shared memory at all.

On Fri, Apr 20, 2012 at 7:27 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 04/20/2012 04:21 PM, Roger Sibert wrote:
>> I was thinking along the lines of adding a command, job_size_allowed =3D
>> default, (l)arge, (xl)arge, (j)umbo with using those in where you do the
>> check FIO_MAX_JOBS or REAL_MAX_JOBS.
>>
>> Default=3D1
>> Large=3D1.5
>> XLarge=3D2
>> Jumbo=3D3
>>
>> char output[(REAL_MAX_JOBS*job_size_allowed) + 512], *p =3D output;
>>
>> Sorry if the code is off/wrong, I have spent the last 5 days doing
>> nothing but perl and bash scripting along with a twist of SQL so my
>> brain is mush :P
>>
>> I used to test RAID code for a living so I wasn't about to start digging
>> since I don't know the code well enough which means that if I push in on
>> one side something else will more than likely pop out on the other.
>>
>> Looking at what your describing vs what I was thinking it sounds like
>> your approach of setting it up to allow for a more dynamic range would
>> be a more elegant approach that would serve better in the long run.
>
> Yes, the point of doing segmented thread_data arrays would be to get rid
> of any fio imposed constraint on the number of jobs that could be
> supported. And do so without requiring tweaking of the shm segment size
> on the OS in question.
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =EF=BF=BDhttp://vger.kernel.org/majordomo-info.html
