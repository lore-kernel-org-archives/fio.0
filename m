Return-Path: <fio-owner@vger.kernel.org>
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57127 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730294AbgKIOg0 (ORCPT
        <rfc822;fio@vger.kernel.org>); Mon, 9 Nov 2020 09:36:26 -0500
Date: Mon, 9 Nov 2020 14:36:16 +0000
From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: [PATCH, RFC] list all available dynamic ioengines with --enghelp
Message-ID: <20201109143616.GB9867@redhat.com>
References: <30a0bc27-4938-0ef3-ffa9-5e06fb8efb3c@redhat.com>
 <b1864b03-e0fe-2ffd-7a33-5875b3c31760@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1864b03-e0fe-2ffd-7a33-5875b3c31760@sandeen.net>
List-Id: fio@vger.kernel.org
To: Eric Sandeen <sandeen@sandeen.net>
Cc: fio <fio@vger.kernel.org>

On Sat, Nov 07, 2020 at 12:15:18PM -0600, Eric Sandeen wrote:
> On 11/6/20 4:07 PM, Eric Sandeen wrote:
> > When dynamic engines are enabled, "fio --enghelp" does not list all
> > available engines as the man page says it will:
> > 
> > 	If no ioengine is given, list all available ioengines.
> > 
> > Fix this by opening FIO_EXT_ENG_DIR and attempting dlopen_ioengine
> > everything that's found there.
> 
> The last(?) thing that would be nice to fix for the dynamic engines is to
> not hardcode FIO_EXT_ENG_DIR to /usr/lib/fio since many systems will
> be using /usr/lib64, but I'm not really sure how to do that best in
> the hardcoded configure world of fio ... I could hack something up.

Not to mention FreeBSD which seems to be using /usr/local/lib, or
would do if they had enabled the modules
(https://www.freshports.org/benchmarks/fio/).

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
libguestfs lets you edit virtual machines.  Supports shell scripting,
bindings from many languages.  http://libguestfs.org


