Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:35406 "EHLO
        mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751113AbeCIHRp (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 9 Mar 2018 02:17:45 -0500
Received: by mail-vk0-f43.google.com with SMTP id b65so1535885vka.2
        for <fio@vger.kernel.org>; Thu, 08 Mar 2018 23:17:45 -0800 (PST)
MIME-Version: 1.0
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 9 Mar 2018 07:17:14 +0000
Message-ID: <CALjAwxiK8XcaUaCS+=31iowikHCHRO_js0+R8TYnzwhg4fbjiQ@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=E7=AD=94=E5=A4=8D=3A_=E7=AD=94=E5=A4=8D=3A_How_to_ensure_split_verification?=
        =?UTF-8?Q?_will_generate_the_same_configs_as_write_phase=3F?=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Vaughan <cxt9401@163.com>
Cc: fio <fio@vger.kernel.org>

On 9 March 2018 at 06:11, Vaughan <cxt9401@163.com> wrote:
>
> Can you further explain the usage of  --verify_state_save --verify_backlo=
g --verify_backlog_batch options?

(I'll just note, if you change the topic of discussion it's usually
better netiquette to start a new email thread rather than continue an
old topic)

There are explanations on
http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-verify-state=
-save
, http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-verify-bac=
klog
, http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-verify-bac=
klog-batch
if you haven't seen them already. It's worth noting that
verify_state_save isn't really anything to do with verify_backlog. A
bit of background:

Normally when you run a write job with verification turned on
(remember do_verify defaults to 1 if verification has been enabled) it
will
1. Do all the writes (so called "write phase")
2. After the last write has finished, it will do reads of the all the
writes done to verify them ("verification phase").

1 and 2 happen as part of the same job (side note: to stop 2. from
occuring you would need to use do_verify=3D0)! However a bit of memory
is chewed up for each region written to do this style of verification
because fio actually builds verification log during 1 and then uses
that log in 2.

When you also enable verify_backlog the following happens instead:
1a. Do some writes.
1b. After verify_backlog writes are done verify the data performed by
the most recent 1a. writes.
1c. Go to 1a and repeat until all blocks have been written and verified.

Verification is still done as part of the same job but it is done
inline with the writes during the "write phase" and there's no
separate "verification phase" after all the writes finish. This means
the verification log size will be bounded to no more than
verify_backlog amount (which saves memory). For an explanation of
verify_backlog_batch I'd recommend reading the HOWTO link from earlier
and asking specific questions if that explanation is unclear.

verify_state_save saves key values into a file which can then be
reloaded in an entirely separate fio invocation (e.g. to know how far
through fio got doing writes). A side note is that separate
verification invocations generally have less information available to
them at verification time in comparison to in-job verifications.

> I need to split verify tera-byte size of data. According to the HOWTO of =
fio to avoid memory exhaustion, verify_backlog should be used. so I do the =
write job with "--verify_state_save=3D1 --verify_backlog=3D1 --verify_backl=
og_batch=3D10240" in cmd line and do a split verify by appending "--verify_=
only" with the same write command options. But it seems it just verify the =
10240 ios, not the same size as write job.

If you have the memory you can certainly wait for the verification
phase to kick in after all the writes are done and make use of the
in-job verify. However verify_backlog doesn't make sense if you are
not performing writes in that exact same job (as there are no writes
to verify inline) and in the above you are turning off the writes when
you use verify_only. Additionally if you are aren't doing any sort of
in-job verification fio won't bother keeping a verification log in
memory.

> Only if I verify without "--verify_state_save=3D1 --verify_backlog=3D1 --=
verify_backlog_batch=3D10240", it verify the whole size I write. I get the =
conclusion by run the write work and verify work with "write_iolog=3Dstr" a=
nd compare the iolog, and also "ios=3D" in "Disk stats" section of both fio=
 output.

"--verify_backlog=3D1 --verify_backlog_batch=3D10240" seems unusual
combination of values to use - can you explain what you think this
does (make sure you've read the HOWTO paragraph about it)?

> Another question about write process with "rw=3Drandwrite" and "bsrange=
=3D". If run it with "ioengine=3Dlibaio iodepth=3D16", will this async writ=
e get any overlap?

Maybe (but you can check the "IO depths" output to see what was
actually achieved)? Did you see the warning for libaio in the ioengine
section of the HOWTO
(http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-ioengine
and look at the libaio heading)?

--=20
Sitsofe | http://sucs.org/~sits/
