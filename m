Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:9234 "EHLO
	mx0a-000cda01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753213AbcEXDww convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 23 May 2016 23:52:52 -0400
Received: from pps.filterd (m0075554.ppops.net [127.0.0.1])
	by mx0a-00003501.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u4O3ovsL038294
	for <fio@vger.kernel.org>; Mon, 23 May 2016 23:52:51 -0400
Received: from mail-io0-f198.google.com (mail-io0-f198.google.com [209.85.223.198])
	by mx0a-00003501.pphosted.com with ESMTP id 234fdpr01p-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Mon, 23 May 2016 23:52:51 -0400
Received: by mail-io0-f198.google.com with SMTP id d197so13673449ioe.1
        for <fio@vger.kernel.org>; Mon, 23 May 2016 20:52:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALjAwxgtwP+6K0qLnNzm2Z72gLGasd_oG6EH66bjV-Rc6rOEpw@mail.gmail.com>
References: <CANo=J15Pt4+=G4dmq+hwUGH+3-OP4wWvqO44dbZLNOZaQYcmRQ@mail.gmail.com>
	<CANvN+enHvuNd5TC=Qxte22k52qR3XdLzyeGxQ5OLihwOM0XDRQ@mail.gmail.com>
	<CALjAwxgtwP+6K0qLnNzm2Z72gLGasd_oG6EH66bjV-Rc6rOEpw@mail.gmail.com>
Date: Mon, 23 May 2016 21:52:50 -0600
Message-ID: <CANo=J17Bu7w2GM5Tb8aB41dvbCFq1n36c2f=+FQDJKpuS82Ydg@mail.gmail.com>
Subject: Re: testing thin provisioned block device
From: Tim Walker <tim.t.walker@seagate.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

This looks interesting.  Thanks!
I will report back...
-Tim

On Mon, May 23, 2016 at 11:41 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> On 23 May 2016 at 16:02, Andrey Kuzmin <andrey.v.kuzmin@gmail.com> wrote:
>>
>> To my knowledge, there's no prebuilt configuration to read only those blocks
>> that have been written before.
>>
>> At the same time, when randommap is on, FIO keeps track of the blocks written,
>> so it may be possible to limit the read generation to those by adding
>> a bit of code.
>
> I thought this type of facility had to exist so that verification
> triggers (https://urldefense.proofpoint.com/v2/url?u=https-3A__github.com_axboe_fio_blob_fio-2D2.10_HOWTO-23L2214&d=CwIBaQ&c=IGDlg0lD0b-nebmJJ0Kp8A&r=NW1X0yRHNNEluZ8sOGXBxCbQJZPWcIkPT0Uy3ynVsFU&m=kMV_vJkDG44PlTPqwWzkRqZGd9WboeQTwskJijXbUB4&s=hocA_d46stzA2Fk0_dkI2uDHlaEs81U8qVRHKQhSfo0&e=  ) via
> verify_state_load could work?
>
> --
> Sitsofe | https://urldefense.proofpoint.com/v2/url?u=http-3A__sucs.org_-7Esits_&d=CwIBaQ&c=IGDlg0lD0b-nebmJJ0Kp8A&r=NW1X0yRHNNEluZ8sOGXBxCbQJZPWcIkPT0Uy3ynVsFU&m=kMV_vJkDG44PlTPqwWzkRqZGd9WboeQTwskJijXbUB4&s=j0EyneqqMvyjeXgg8I4VEb8qly5XZH14rVVpAtmzXK4&e=



-- 
Tim Walker
Product Design Systems Engineering, Seagate Technology
(303) 775-3770
