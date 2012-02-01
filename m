Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:44883 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab2BABlO convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 31 Jan 2012 20:41:14 -0500
Received: by qafk1 with SMTP id k1so528070qaf.19
        for <fio@vger.kernel.org>; Tue, 31 Jan 2012 17:41:13 -0800 (PST)
MIME-Version: 1.0
From: Steven Lang <tirea@google.com>
Date: Tue, 31 Jan 2012 17:40:53 -0800
Message-ID: <CAAUT-yNTJGUircBV+P3CD3FuozBfTfwLgLwu+JpsED4dTMnNKA@mail.gmail.com>
Subject: A commented out optimization...
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

In comparing the performance between older versions of fio and newer
versions, I noticed right away that pattern writes were slower in fio
2.0.1. =EF=BF=BDRunning perf showed that most of the time spent in fio was =
in
fill_pattern (Over 50% of the CPU time), which was not the case in the
past.

This seems like it is worth it to have around, however a year ago it
was commented out with the following commit log:

Author: Jens Axboe <jaxboe@fusionio.com>  2011-01-14 06:32:30
Committer: Jens Axboe <jaxboe@fusionio.com>  2011-01-14 06:32:30
Parent: 9a793c2f91a47df348237f1a9b778253ca87ec2e (Fix race in exit of
eta/util thread)
Child:  69204d6e8830464bc98fcc28ca91412d6d360775 (Eta/disk thread uses
more than the minimum stack)
Branches: continue_on_error_type_2, master, remotes/origin/master,
remotes/origin/stable-1.x
Follows: fio-1.50-rc2
Precedes: fio-1.50-rc3

    Comment out ->buf_filled_len in pattern fill

    It's buggy, needs to be debugged. Disable for now. It can cause
    verify failures.

    Signed-off-by: Jens Axboe <jaxboe@fusionio.com>

And in the code the comments say "We need to ensure that the pattern
stores are seen before the fill length store, or we could observe
headers that aren't valid to the extent notified by the fill length".

However I'm having trouble imaging a case when that will happen, given
that buffers are filled and consumed within the context of a single
thread.

Do you happen to remember what sort of case was buggy and causing this to f=
ail?
