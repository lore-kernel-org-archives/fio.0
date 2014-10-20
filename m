Return-Path: <fio-owner@vger.kernel.org>
Received: from mx12.netapp.com ([216.240.18.77]:36046 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbaJTPS4 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 20 Oct 2014 11:18:56 -0400
From: "Neto, Antonio Jose Rodrigues" 
	<Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: Simulating file services access
Date: Mon, 20 Oct 2014 15:18:26 +0000
Message-ID: <D06A9FE5.53977%Antonio.Jose.Rodrigues.Neto@netapp.com>
References: <D0615A15.529EB%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <CANQrb8jwNgONAmChLLuT_yF0fBfhvDbjgheN8gGq2rfHV9a84g@mail.gmail.com>
In-Reply-To: <CANQrb8jwNgONAmChLLuT_yF0fBfhvDbjgheN8gGq2rfHV9a84g@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F1E7EC68EDFEAC4F8FE217627813AC12@hq.netapp.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gary Little <gary.j.little@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>



From:  Gary Little <gary.j.little@gmail.com>
Date:  Saturday, October 18, 2014 at 8:04 AM
To:  "Neto, Antonio Jose Rodrigues"
<Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc:  "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject:  Re: Simulating file services access


Hi Neto,

I would suggest using filebench for that sort of workload.

Gary.

On Monday, October 13, 2014, Neto, Antonio Jose Rodrigues
<Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:

Hi All,

This is neto from Brazil

How are you?

I need to mimic a file services workload (1,000,000 files spread across
1000 directories (wide) and 200 directories (deep)). Also, I need to
create files from range 1K to 1MB.

Does anyone have a sample config file for this?

Thank you,

neto

--

Hi Gary,

This is neto from Brazil

How are you?

Hope all is well with you my friend.

Thank you, I will do some tests with filebench.

All the best

neto

