Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:60477 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757230Ab3BSHhW (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 19 Feb 2013 02:37:22 -0500
Received: by mail-ve0-f171.google.com with SMTP id b10so5500878vea.16
        for <fio@vger.kernel.org>; Mon, 18 Feb 2013 23:37:21 -0800 (PST)
MIME-Version: 1.0
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Tue, 19 Feb 2013 01:36:40 -0600
Message-ID: <CAB-428=TxUnVOq-NaJGn35dL0nqtyGWwAH2Aajc+BFjnFn_D7A@mail.gmail.com>
Subject: Timing information between I/Os in iolog replay
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I am trying to understand how fio respect timing information between
consecutive IOs in a read_iolog job, However the logic is not very
clear for me , specially in the following function:

static int read_iolog2(struct thread_data *td, FILE *f)
{
...
r = sscanf(p, "%256s %256s %llu %u", fname, act, &offset,
									&bytes);
...
			if (!strcmp(act, "wait"))
				rw = DDIR_WAIT;
...
		if (rw == DDIR_WAIT) {
			ipo->delay = offset;
...
		queue_io_piece(td, ipo);
}

Here is my two questions about this function:
First, I can not see any "wait" command in a typical iolog file
(collected with write_iolog=str job option). Should I set special
parameter in job file to collect iolog with respect to IO timing
information.
Second, Why request offset assigned to ipo->delay ? I was thinking
that ipo->delay should get some timing value which represent
inter-submission time delay. However, In this case  ipo->delay get LBA
offset which just a byte address in my point view.

Your input is highly appreciated,


Thanks
Alireza
