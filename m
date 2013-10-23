Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab3JWRDy (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 23 Oct 2013 13:03:54 -0400
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: sequential workload
References: <590651218.789538.1382525144344.JavaMail.zimbra@desy.de>
Date: Wed, 23 Oct 2013 13:03:44 -0400
In-Reply-To: <590651218.789538.1382525144344.JavaMail.zimbra@desy.de> (Tigran
	Mkrtchyan's message of "Wed, 23 Oct 2013 12:45:44 +0200 (CEST)")
Message-ID: <x49ob6fyl5b.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Mkrtchyan, Tigran" <tigran.mkrtchyan@desy.de>
Cc: fio@vger.kernel.org

"Mkrtchyan, Tigran" <tigran.mkrtchyan@desy.de> writes:

> Hi,
>
> I need to simulate a workload of generating sequence
> of files - some thing like creating photos.
>
> where is my config:
> [global]
> create_on_open=1
> unlink=1
> filesize=70m
> size=7000m
>
> [pilatus-sec-write]
> rw=write
> openfiles=1
> nrfiles=100
> stonewall
>
>
> I will expect that a combination of create_on_open and openfiles
> will create one file at the time, nevertheless all files get
> created at the same time.

Try adding file_service_type=sequential to your job file.

Cheers,
Jeff
