Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:58481 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab2GaTOZ (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 31 Jul 2012 15:14:25 -0400
Message-ID: <50182E8F.8090006@kernel.dk>
Date: Tue, 31 Jul 2012 21:14:23 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio with fallocate fails with ENOSYS
References: <CAPWDiB2yMrTVbAGiPKN_B4mLU=sL7W1_9Xw7OVM2Or7TDJGXPA@mail.gmail.com>
In-Reply-To: <CAPWDiB2yMrTVbAGiPKN_B4mLU=sL7W1_9Xw7OVM2Or7TDJGXPA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Kevin Castiglia <kcastiglia@aereo.com>
Cc: fio@vger.kernel.org

On 2012-07-12 22:51, Kevin Castiglia wrote:
> Hello,
> 
> fio with fallocate fails with ENOSYS, but I'm unable to reproduce this
> failure outside of fio. The following command:
>     fio --rw=write --fallocate=keep --filename=hello --size=1G
> --runtime=10 --time_based --name=test
> reports an error (if there is no file named 'hello' in my current
> working directory).
> 
> Within the output I see: err=38 (file:filesetup.c:98, func=fallocate,
> error=Function not implemented)
> 
> The following C program prints 0 (if there is no file named testing in
> my current working directory):
> 
> #include <linux/falloc.h>
> #include <stdio.h>
> #include <errno.h>
> 
> int main() {
> 
>     int f = open("testing", "O_CREAT", "0644");
>     int r = fallocate(f, 01, 0, 1073741824);
>     printf("%d\n", r);
> 
> }
> 
> Why is the fio command above failing with ENOSYS when this test
> program runs without errors?
> 
> Also,
> 
>     $ strace fallocate -n -l 1G test
>     ...
>     fallocate(3, 01, 0, 1073741824)         = 0
>     ...
> 
> the fallocate system call seems to work.
> 
> I'm using Fedora 16 , fio 2.07, and an ext4 filesystem
> 
>     $ fio --version
>     fio 2.0.7
> 
>     $ uname -r
>     3.1.0-7.fc16.x86_64
> 
>     $ mount
>     ...
>     /dev/mapper/vg_kcastiglia-lv_home on /home type ext4
> (rw,relatime,seclabel,user_xattr,acl,barrier=1,data=ordered)
>     ...
> 
>     $ ldd --version
>     ldd (GNU libc) 2.14.90
>     ...
> 
>     $ gcc --version
>     gcc (GCC) 4.6.3 20120306 (Red Hat 4.6.3-2)
>     ...

It'd help if you strace (-f) fio to show the issue.

-- 
Jens Axboe

