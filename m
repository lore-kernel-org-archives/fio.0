Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ve0-f177.google.com ([209.85.128.177]:50370 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761306Ab3DDSdB (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 4 Apr 2013 14:33:01 -0400
Received: by mail-ve0-f177.google.com with SMTP id jw11so2929607veb.36
        for <fio@vger.kernel.org>; Thu, 04 Apr 2013 11:33:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <515DAA33.4000009@warnerbros.com>
References: <515DAA33.4000009@warnerbros.com>
Date: Thu, 4 Apr 2013 11:33:00 -0700
Message-ID: <CAN2qFapd8shvoG+eJSa5TRv-jzW-Cms-PKJM+PcxUGeXnwGBJw@mail.gmail.com>
Subject: Re: How to re-use default sequential filenames?
From: Matt Hayward <matt.hayward@delphix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Alan Hagge <Alan.Hagge@warnerbros.com>
Cc: fio <fio@vger.kernel.org>

Hello Alan,
    I don't have facts to back this up, but here are two things you might try:

1) Can you get away with naming your two jobs ([write] and [read]) the
same thing? E.g. [myjob]?

2) I think filename takes a colon seperated list optionally.  Have you
tried specifying:
filename=file1:file2:file3:...

In each of your jobs?

It seems possible that doing this for 20000 files might create a
problem with the length of the parameter...






On Thu, Apr 4, 2013 at 9:28 AM, Alan Hagge <Alan.Hagge@warnerbros.com> wrote:
> I'm trying to put together a test of the write and read speed to some new
> SAN storage.  Our workflow involves writing large numbers of 12 MiB files
> (on the order of 20,000 or so) at a time.  I'd like to set up a config file
> section that will write all 20,000 files then read all 20,000 files and
> report on the write performance and the read performance (separately).
>
> I've tried something like this:
>
> [global]
> blocksize=4m
> filesize=12m
> nrfiles=20000
> openfiles=1
> file_service_type=sequential
> create_on_open=1
> ioengine=posixaio
>
> [write]
> rw=write
>
> [read]
> stonewall
> rw=read
>
> But the issue is that the files get created with default filenames
> (write.1.1, write.1.2, etc.), so that when the read job is run, it can't
> find any files (since it expects the files to be named read.1.1, read.1.2,
> etc.).  If I try to specify the "filename=" option in either section, fio no
> longer appends the ".<thread>.<sequence>" to the filename, but rather tries
> to do all I/O to a single file.
>
> Is there a syntax for the "filename=" option that will allow me to specify a
> different root filename, but still use the ".<thread>.<sequence>" naming
> convention?  Failing that, is there any other way to accomplish my goal?
>
> Thanks for any tips, pointers, etc.
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Matthew Hayward
Director Professional Services
Delphix:
https://www.facebook.com/DelphixCorp
https://twitter.com/delphixcorp
M: 206.849.6389
275 Middlefield Road, Suite 50
Menlo Park, CA 94025
http://www.delphix.com
