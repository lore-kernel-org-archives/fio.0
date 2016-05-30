Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0b-00003501.pphosted.com ([67.231.152.68]:48891 "EHLO
	mx0a-000cda01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161220AbcE3QS1 convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 30 May 2016 12:18:27 -0400
Received: from pps.filterd (m0075030.ppops.net [127.0.0.1])
	by mx0b-00003501.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u4UGGuUq046018
	for <fio@vger.kernel.org>; Mon, 30 May 2016 12:18:26 -0400
Received: from mail-ig0-f197.google.com (mail-ig0-f197.google.com [209.85.213.197])
	by mx0b-00003501.pphosted.com with ESMTP id 238rw9802q-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Mon, 30 May 2016 12:18:25 -0400
Received: by mail-ig0-f197.google.com with SMTP id q18so120442327igr.2
        for <fio@vger.kernel.org>; Mon, 30 May 2016 09:18:25 -0700 (PDT)
From: Tim Walker <tim.t.walker@seagate.com>
Mime-Version: 1.0 (1.0)
References: <CAMy1HkEAccd5FwvUKpJMuaKtcGa_T18GXdivR06S8Ne7m0Qq=w@mail.gmail.com>
In-Reply-To: <CAMy1HkEAccd5FwvUKpJMuaKtcGa_T18GXdivR06S8Ne7m0Qq=w@mail.gmail.com>
Date: Mon, 30 May 2016 10:18:23 -0600
Message-ID: <6630302606885540555@unknownmsgid>
Subject: Re: fio error when using direct=1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Nitin Mathur <nitinmathur@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Others could probably answer, but in the meantime could you try
changing the 512B bssplit to 4K? I admit it's a bit of a swag...

Tim Walker
Systems Engineering


> On May 30, 2016, at 9:37 AM, Nitin Mathur <nitinmathur@gmail.com> wrote:
>
> I am getting the following error and need help from someone
>
> Test environment
> CentOS 6.5
> Linux kernel: 3.8.8, 64 bit
> FIO version: fio-2.11
>
> I run the following command
>
>> ./fio --name=test_workld --ioengine=libaio --direct=1 --rw=randrw --norandommap --randrepeat=0 --rwmixread=40 --rwmixwrite=60 --iodepth=256 --size=100% --numjobs=4 --bssplit=512/4:64k/96 --random_distribution=zoned:50/5:50/95 --overwrite=1 --output=test_op --filename=/dev/nvme0n1 --group_reporting --runtime=1m --time_based
>
>
> This means, I'm using libaio, with a queue depth of 256, and fio is
> utilizing asynchronous IO engines. But when i run this command, it
> results into an error "Invalid argument". If i change the parameter
> --direct=0, I'm able to issue the command successfully.
>
> Can you help me to understand, why with direct=1, the fio command
> results in an error  ?
>
> Thanks
> Nitin
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=CwIDaQ&c=IGDlg0lD0b-nebmJJ0Kp8A&r=NW1X0yRHNNEluZ8sOGXBxCbQJZPWcIkPT0Uy3ynVsFU&m=iq608km1yBu7HmXRbaOtJbbsTztTq7_DHpO8EmfutZU&s=SKPO5VaH1JwEZGe0QKLLDQOCy6njnE5FT-DYzNRDWBQ&e=
