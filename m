Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:35188 "EHLO
	mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbbDHCFl (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 7 Apr 2015 22:05:41 -0400
Received: by qkhg7 with SMTP id g7so68208219qkh.2
        for <fio@vger.kernel.org>; Tue, 07 Apr 2015 19:05:40 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 7 Apr 2015 23:05:40 -0300
Message-ID: <CAENGNheNV+BP6eq9cHUrS+rp2tHxfoDfEK2vrfxPizLdws_cig@mail.gmail.com>
Subject: Question regarding fio build system
From: Raphael Philipe <rapphil@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I'm working with fio in the context of the meta-openembedded layer of
the Yocto project.

To make the long story short, while building fio 2.2.6, I noticed that
it has some floating dependencies on zlib and numa if you just try to
hit the 'make' cmd. (When you do that, the Makefile will execute the
configure script that tries to detect some libraries).

I've found the following comment in the configure script: "Sad this
this is easier than autoconf and enemies.". I'm evaluating the effort
to enable fio to be built using autotools and have the following
questions regarding this:

 - Is there any particular reason to the build process to be like
this, besides the comment that I pointed out?

- If fio supported autotools, it would make my life easier :). Is
there any plans to move fio to use it? Is there any work in progress
around it? If not, I would be very pleased to provide this change on
your guidance. Do you guys agree with that?

Regards,
Raphael Philipe Mendes da Silva.
