Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.32.201]:36871 "EHLO mail.cs.umn.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbcCNSjV convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 14 Mar 2016 14:39:21 -0400
Received: from localhost (enchanter.cs.umn.edu [160.94.22.228])
	by mail.cs.umn.edu (Postfix) with ESMTP id DE791405DA3
	for <fio@vger.kernel.org>; Mon, 14 Mar 2016 13:39:19 -0500 (CDT)
Received: from mail.cs.umn.edu ([128.101.32.201])
	by localhost (enchanter.cs.umn.edu [160.94.22.228]) (amavisd-new, port 10024)
	with ESMTP id twvS4vZrsDQo for <fio@vger.kernel.org>;
	Mon, 14 Mar 2016 13:39:18 -0500 (CDT)
Received: from mail-io0-f173.google.com (mail-io0-f173.google.com [209.85.223.173])
	by mail.cs.umn.edu (Postfix) with ESMTPSA id EF55B405CA9
	for <fio@vger.kernel.org>; Mon, 14 Mar 2016 13:37:10 -0500 (CDT)
Received: by mail-io0-f173.google.com with SMTP id m184so233732215iof.1
        for <fio@vger.kernel.org>; Mon, 14 Mar 2016 11:37:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c0aff70ec5314c33a41556b828fb7bd1@AUSX13MPC107.AMER.DELL.COM>
References: <e0428ae214c0407bb565172a563e79ad@AUSX13MPC103.AMER.DELL.COM>
 <BN3PR0401MB1457AF32B8D51A1BC9512D4AF7880@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <c0aff70ec5314c33a41556b828fb7bd1@AUSX13MPC107.AMER.DELL.COM>
From: Alireza Haghdoost <alireza@cs.umn.edu>
Date: Mon, 14 Mar 2016 13:36:31 -0500
Message-ID: <CAB-428nKSCiuYQphBf7Ti0saWM8WkjL7kdr6wYw7ePxgKjHWXw@mail.gmail.com>
Subject: Re: Monitor IO while fio is running
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Kurt_Dorsey@dell.com
Cc: jeff.furlong@hgst.com, "fio@vger.kernel.org" <fio@vger.kernel.org>

You should be able to redirect it to a file. Would you mind share with
us how you set the redirection?

On Mon, Mar 14, 2016 at 1:03 PM,  <Kurt_Dorsey@dell.com> wrote:
> Thank you Jeff for the reply.
>
> I have been playing around with this but unfortunately I cannot get the output to be outputted anywhere other than the screen / terminal.  I  have tried redirecting it to a txt file and parsing with with a python script but nothing ever gets output. (It only outputs to the screen)
>
> I haven't done C programming in years but I am trying to figure out from the code why this is.  I see in the eta.c file
>
> void display_thread_status(struct jobs_eta *je)
> {
> ...
>        printf("%s", output);
>
>         if (!eta_new_line_init) {
>                 fio_gettime(&disp_eta_new_line, NULL);
>                 eta_new_line_init = 1;
>         } else if (eta_new_line && mtime_since_now(&disp_eta_new_line) > eta_new_line) {
>                 fio_gettime(&disp_eta_new_line, NULL);
>                 eta_new_line_pending = 1;
>         }
>
>         fflush(stdout);
>
>
> It prints everything to the screen but I cannot redirect it at all
>
> Thoughts?
> Thank you,
> Kurt
>
>
> -----Original Message-----
> From: Jeff Furlong [mailto:jeff.furlong@hgst.com]
> Sent: Monday, March 14, 2016 12:56 PM
> To: Dorsey, Kurt ; fio@vger.kernel.org
> Subject: RE: Monitor IO while fio is running
>
> You might add --eta=always and --eta-newline=1 to get the current IOPs rate every 1s, printed to stdout. You can parse that current IOPs rate via a script and do something. I believe the IOPs rate is recalculated every 1s, not the average from beginning of test.
>
> Not sure why --eta and --eta-newline is not in the latest HOWTO notes.
>
> Regards,
> Jeff
>
> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of Kurt_Dorsey@Dell.com
> Sent: Saturday, March 12, 2016 2:20 PM
> To: fio@vger.kernel.org
> Subject: Monitor IO while fio is running
>
> I may just not know how to do this
> I know about the ability to touch /tmp/fio-dump-status which will dump the output of fio to a file or stdout while the test is running. What I am looking for is to be able to dump the write_iops_log while fio is running so that I can see the point in time average IOps for a given interval For example if I have log_avg_msec=60000 it will write an iops.log file with 60second intervals, unfortunately this file doesn't get created until fio exits. Is there a way to get this to dump on a regular basis (or by touching a file in /tmp) so that I can tail the output?
>
> I am looking for a way to get point in time status via a script and the output from tmp-dump-status only gives me averages from the start of time rather than the last interval
>
> Thank you,
> Kurt
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in the body of a message to majordomo@vger.kernel.org More majordomo info at http://vger.kernel.org/majordomo-info.html
> Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:
>
> This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
