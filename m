Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:43461 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaJTRjh (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 20 Oct 2014 13:39:37 -0400
Received: by mail-la0-f52.google.com with SMTP id hz20so4351371lab.39
        for <fio@vger.kernel.org>; Mon, 20 Oct 2014 10:39:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <D06A9FE5.53977%Antonio.Jose.Rodrigues.Neto@netapp.com>
References: <D0615A15.529EB%Antonio.Jose.Rodrigues.Neto@netapp.com>
	<CANQrb8jwNgONAmChLLuT_yF0fBfhvDbjgheN8gGq2rfHV9a84g@mail.gmail.com>
	<D06A9FE5.53977%Antonio.Jose.Rodrigues.Neto@netapp.com>
Date: Mon, 20 Oct 2014 18:39:36 +0100
Message-ID: <CALjAwxjfNz8JSNTf7JoDT9K3y=LePTLofR05YC0HWh0eNdoL6Q@mail.gmail.com>
Subject: Re: Simulating file services access
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: Gary Little <gary.j.little@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 20 October 2014 16:18, Neto, Antonio Jose Rodrigues
<Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:
>
> From:  Gary Little <gary.j.little@gmail.com>
> Date:  Saturday, October 18, 2014 at 8:04 AM
> To:  "Neto, Antonio Jose Rodrigues"
> <Antonio.Jose.Rodrigues.Neto@netapp.com>
> Cc:  "fio@vger.kernel.org" <fio@vger.kernel.org>
> Subject:  Re: Simulating file services access
>
> Hi Neto,
>
> I would suggest using filebench for that sort of workload.
>
> Gary.
>
> On Monday, October 13, 2014, Neto, Antonio Jose Rodrigues
> <Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:
>
> Hi All,
>
> This is neto from Brazil
>
> How are you?
>
> I need to mimic a file services workload (1,000,000 files spread across
> 1000 directories (wide) and 200 directories (deep)). Also, I need to
> create files from range 1K to 1MB.
>
> Does anyone have a sample config file for this?
>
> Thank you,
>
> neto
>
> --
>
> Hi Gary,
>
> This is neto from Brazil
>
> How are you?
>
> Hope all is well with you my friend.

Now you're a bona fide fio mailing list regular you can skip the greets :-)

> Thank you, I will do some tests with filebench.

You can also try Crefi (https://github.com/vijaykumar-koppad/Crefi ),
genbackupdata (http://liw.fi/genbackupdata/ ) or impressions
(https://github.com/kdave/impressions ). This mailing list might not
be the best place for filesystem testing tools though...

-- 
Sitsofe | http://sucs.org/~sits/
