Return-Path: <fio-owner@vger.kernel.org>
Received: from secvs01.rockwellcollins.com ([205.175.225.240]:14787 "EHLO
	secvs01.rockwellcollins.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932418AbaIEN6P (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 5 Sep 2014 09:58:15 -0400
Received: by mail-ie0-f170.google.com with SMTP id tp5so572073ieb.1
        for <fio@vger.kernel.org>; Fri, 05 Sep 2014 06:48:39 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 5 Sep 2014 08:42:23 -0500
Message-ID: <CANQCQpamy7TCmgtZBwtzcKH3KMZnJZ1tguPRGr2Xa63Axo3P1w@mail.gmail.com>
Subject: fio-2.1.4 - dlopen failed for libaio
From: Matthew Weber <matthew.weber@rockwellcollins.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Status output from a case where fio is built without libaio support....
     fio: engine libaio not loadable
     fio: failed to load engine libaio
     fio: file:ioengines.c:102, func=dlopen, error=libaio: cannot open
shared object file: No such file or directory

I don't think this is necessarily a bug, but I wanted to comment on
what we observed.  There was some discussion on this on the buildroot
mailing list since we thought we needed to force a dependency on
having libaio always built as a dependency for the fio package to link
against.  Instead the user just needs to enable the libaio if they use
it as an engine (which is fine).
http://buildroot-busybox.2317881.n4.nabble.com/PATCH-v4-fio-add-missing-libaio-dependency-td77314.html

Here our interpretation of what's happening.... It looks like the
shared library open error is one of the expected failure outputs if
you don't have support for the specific dynamic "io library".  The
build of the fio package does correctly determine if the libaio lib is
present or not and correctly adds it to the ioengines list for use (at
build time, so the enghelp output is correct, etc).  However when fio
is executed, it looks up if a "set of operations" is registered for
whichever ioengine library used.  If they are, it goes ahead and uses
them.  If they need to be loaded, like in the case of libaio, it
attempts to load them. However there is no check to see if fio was
built with support for the external library being loaded (like in this
case of libaio).

Thanks,
-- 
Matthew L Weber / Pr Software Engineer
Airborne Information Systems / Security Systems and Software
MS 131-100, C Ave NE, Cedar Rapids, IA, 52498, USA
www.rockwellcollins.com

Note: Any Export License Required Information and License Restricted
Third Party Intellectual Property (TPIP) content must be encrypted and
sent to matthew.weber@corp.rockwellcollins.com.
