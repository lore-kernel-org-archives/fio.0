Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:53447 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005Ab2JASGa (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 1 Oct 2012 14:06:30 -0400
Received: by oagh16 with SMTP id h16so5355051oag.19
        for <fio@vger.kernel.org>; Mon, 01 Oct 2012 11:06:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAN2qFarhzbKK2m2T5mRjcL7OMkXuRYN+XicUg0nDdw5adpbheA@mail.gmail.com>
References: <CA+oXfEHeas9UfK=6p-B3ugqUxxFFNFjepAX3jF_=yXHZcOYf3A@mail.gmail.com>
	<CAN2qFarhzbKK2m2T5mRjcL7OMkXuRYN+XicUg0nDdw5adpbheA@mail.gmail.com>
Date: Mon, 1 Oct 2012 11:06:30 -0700
Message-ID: <CAN2qFar7i_xu38HUHB4r8rfqxa3YSDB3MDZArbPhz0BG8hz=7Q@mail.gmail.com>
Subject: Re: How to create multiple files with FIO?
From: Matt Hayward <matt.hayward@delphix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Ashish Barot <barotashish@gmail.com>
Cc: fio@vger.kernel.org

Hello Ashish,
    Here are my opinions on the topics below - hopefully someone will
correct me if I'm wrong.

On Mon, Oct 1, 2012 at 1:40 AM, Ashish Barot <barotashish@gmail.com> wrote:
>
>  Hi All,
>
> I am new to this tool, could anyone please guide me for following things.
>
> [1] How can I create thousands of files and directories? Can I do
> these two task  with one job only?


I would begin by downloading the source and reading the HOWTO and
README documents for usage.

The nrfiles argument controls how many files get created by fio automatically.

For example, this jobfile:

[thousand-files]
directory=/tmp
nrfiles=1000
size=1000k
bs=1k
rw=read

Creates 1000 files of 1 KB each in /tmp, and then performs 1k
sequential reads on each of them.

My understanding is that the created file sizes will be:

size/nrfiles

unless filesize= is specified, in which case all files would be of filesize.

I also believe that only the first size/nrfiles bytes of a file will
be used (unless offset= is specified), and that size/nrfiles of I/O
will be performed on each file (again, probably configurable with
other options).

I do not believe fio is intended to evaluate the performance of file
creation however - fio is designed to evaluate the workloads
documented under the:

rw=

Parameter, file creation is just a side effect of establishing the
desired environment for the rw= I/O patterns.

>
> [2] How can I create fragmented I/O?
>

If you mean non-sequential I/O, then the:
rw=randread
rw=randwrite
rw=rw
Options perform random I/O.




>
> [3] Can we check data integrity with FIO?
>
>

You can check that the storage is faithfully reading the values
written I think - see the do_verify and verify arguments - I haven't
used these myself.



>
>
>  Thanks in advance.
>
>  Best Regards,
>  Ashish Barot.
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




--
Matthew Hayward
Director Professional Services
Delphix

M: 206.849.6389
275 Middlefield Road, Suite 50
Menlo Park, CA 94025
http://www.delphix.com



-- 
Matthew Hayward
Director Professional Services
Delphix

M: 206.849.6389
275 Middlefield Road, Suite 50
Menlo Park, CA 94025
http://www.delphix.com
