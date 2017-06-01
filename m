Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:35172 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751162AbdFARm4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Jun 2017 13:42:56 -0400
Received: by mail-vk0-f46.google.com with SMTP id w1so28672792vkd.2
        for <fio@vger.kernel.org>; Thu, 01 Jun 2017 10:42:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB1457718D031C1B5192A2D5938FFE0@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <CAF+0mvkqR953QypN3dRxuiG4fgbQxoMsGfft2YpZezfc0M4spg@mail.gmail.com>
 <BN3PR0401MB1457718D031C1B5192A2D5938FFE0@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Matthew Eaton <m.eaton82@gmail.com>
Date: Thu, 1 Jun 2017 10:42:54 -0700
Message-ID: <CAF+0mvnGttvUja=NfW-0iiq-tvdc9d_OLJNAzmdUuuE=biGjCg@mail.gmail.com>
Subject: Re: SSD Test Recommendation
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Furlong <jeff.furlong@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Tue, May 23, 2017 at 5:34 PM, Jeff Furlong <jeff.furlong@wdc.com> wrote:
> Generally speaking, it is best to preconditon with the block size you int=
end to test.  There are some exceptions but they are device dependent and v=
ary from one SSD to another.  Depending upon your quality of service test (=
are you measuring steady state IOPs or latency or something else?), you may=
 notice these differences in your 8k results.
>
> Regards,
> Jeff
>
> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Beh=
alf Of Matthew Eaton
> Sent: Monday, May 22, 2017 3:32 PM
> To: fio@vger.kernel.org
> Subject: SSD Test Recommendation
>
> Hi guys,
>
> I want to run a quality of service test on SSDs with bs=3D4k and bs=3D8k =
but I need some help.
> I'm wondering if it's okay to test both 4k then 8k like this:
>
> purge
> precondition with 128k write
> run 4k read test
> run 8k read test
> precondition to steady state with 4k write run 4k write test run 8k write=
 test
>
> Will the 8k test results be invalid due to the 4k write history?
>
> Thanks!
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in the bod=
y of a message to majordomo@vger.kernel.org More majordomo info at  http://=
vger.kernel.org/majordomo-info.html
> Western Digital Corporation (and its subsidiaries) E-mail Confidentiality=
 Notice & Disclaimer:
>
> This e-mail and any files transmitted with it may contain confidential or=
 legally privileged information of WDC and/or its affiliates, and are inten=
ded solely for the use of the individual or entity to which they are addres=
sed. If you are not the intended recipient, any disclosure, copying, distri=
bution or any action taken or omitted to be taken in reliance on it, is pro=
hibited. If you have received this e-mail in error, please notify the sende=
r immediately and delete the e-mail in its entirety from your system.


Hi Jeff,

Thanks for your insight. I was leaning the same way but figured I
would consult the experts first. :)
