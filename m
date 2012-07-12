Return-Path: <fio-owner@vger.kernel.org>
Received: from exprod7og109.obsmtp.com ([64.18.2.171]:40281 "HELO
	exprod7og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933478Ab2GLU5P (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 12 Jul 2012 16:57:15 -0400
Received: by obbup19 with SMTP id up19so3924182obb.12
        for <fio@vger.kernel.org>; Thu, 12 Jul 2012 13:57:13 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 12 Jul 2012 16:51:38 -0400
Message-ID: <CAPWDiB2yMrTVbAGiPKN_B4mLU=sL7W1_9Xw7OVM2Or7TDJGXPA@mail.gmail.com>
Subject: fio with fallocate fails with ENOSYS
From: Kevin Castiglia <kcastiglia@aereo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

fio with fallocate fails with ENOSYS, but I'm unable to reproduce this
failure outside of fio. The following command:
    fio --rw=write --fallocate=keep --filename=hello --size=1G
--runtime=10 --time_based --name=test
reports an error (if there is no file named 'hello' in my current
working directory).

Within the output I see: err=38 (file:filesetup.c:98, func=fallocate,
error=Function not implemented)

The following C program prints 0 (if there is no file named testing in
my current working directory):

#include <linux/falloc.h>
#include <stdio.h>
#include <errno.h>

int main() {

    int f = open("testing", "O_CREAT", "0644");
    int r = fallocate(f, 01, 0, 1073741824);
    printf("%d\n", r);

}

Why is the fio command above failing with ENOSYS when this test
program runs without errors?

Also,

    $ strace fallocate -n -l 1G test
    ...
    fallocate(3, 01, 0, 1073741824)         = 0
    ...

the fallocate system call seems to work.

I'm using Fedora 16 , fio 2.07, and an ext4 filesystem

    $ fio --version
    fio 2.0.7

    $ uname -r
    3.1.0-7.fc16.x86_64

    $ mount
    ...
    /dev/mapper/vg_kcastiglia-lv_home on /home type ext4
(rw,relatime,seclabel,user_xattr,acl,barrier=1,data=ordered)
    ...

    $ ldd --version
    ldd (GNU libc) 2.14.90
    ...

    $ gcc --version
    gcc (GCC) 4.6.3 20120306 (Red Hat 4.6.3-2)
    ...

Thanks for your help,
  Kevin Castiglia
