Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qy0-f112.google.com ([209.85.221.112]:62914 "EHLO
	mail-qy0-f112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbZDZCso convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 25 Apr 2009 22:48:44 -0400
Received: by qyk10 with SMTP id 10so518425qyk.33
        for <fio@vger.kernel.org>; Sat, 25 Apr 2009 19:48:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6863f0c90904251938v2fd125egaf900257c1eb33dd@mail.gmail.com>
References: <6863f0c90904251938v2fd125egaf900257c1eb33dd@mail.gmail.com>
Date: Sat, 25 Apr 2009 21:48:43 -0500
Message-ID: <6863f0c90904251948o5d4e8c36y75c9042c0ae800cd@mail.gmail.com>
Subject: Re: "directory=" option not working??
From: John Cagle <jcagle@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

More info:  It looks like the [global] filename is not affected by the
[global] directory, but if you move the filename down into a job
section, it will get the directory name prepended...

John

On Sat, Apr 25, 2009 at 9:38 PM, John Cagle <jcagle@gmail.com> wrote:
> I just tried the new ssd-test config file, and it uses a "directory=3D"
> option in the global section.
>
> I specify "directory=3D/mnt" but it doesn't work. =EF=BF=BDI have an SSD =
mounted
> at /mnt, but the files created by fio keep appearing in the cwd.
>
> Can someone double check this on their system? =EF=BF=BDI'm working with =
the
> latest source of fio, building it on Ubuntu x86_64.
>
> John
