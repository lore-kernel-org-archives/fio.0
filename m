Return-Path: <fio-owner@vger.kernel.org>
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27799 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727457AbfLCVlq (ORCPT
        <rfc822;fio@vger.kernel.org>); Tue, 3 Dec 2019 16:41:46 -0500
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: rwmixread
References: <CAHEKYV4x7Re+sa1AADW00j0nR0C7+PUXr8gh7vby4d2h084KjQ@mail.gmail.com>
        <CALjAwxiRRM2sJ7s_Ej0ZShfO1JcA774ZnDNCw1mF4A9txVMcCw@mail.gmail.com>
        <AT5PR8401MB1169A13E33A093D959958D91AB420@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
Date: Tue, 03 Dec 2019 16:41:41 -0500
In-Reply-To: <AT5PR8401MB1169A13E33A093D959958D91AB420@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
        (Robert Elliott's message of "Tue, 3 Dec 2019 01:03:29 +0000")
Message-ID: <x49a789qe7e.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

"Elliott, Robert (Servers)" <elliott@hpe.com> writes:

>> -----Original Message-----
>> From: fio-owner@vger.kernel.org <fio-owner@vger.kernel.org> On Behalf
>> Of Sitsofe Wheeler
>> Sent: Friday, November 29, 2019 1:54 AM
>> To: Mauricio Tavares <raubvogel@gmail.com>
>> Cc: fio <fio@vger.kernel.org>
>> Subject: Re: rwmixread
> ...
>> A brief reminder to anyone reading: if you're publishing results
>> don't forget to abide by fio's MORAL-LICENSE
>> (https://github.com/axboe/fio/blob/master/MORAL-LICENSE ) as things
>> like version number or whether your fio is custom fork can help
>> others understand how to reproduce your results.
>>=20
>
> People working with fio source code might see that file, but users of
> precompiled binaries in a distro won't; all that they'll see is=20
> whatever fio outputs and the manpage.

# cat /etc/redhat-release=20
Red Hat Enterprise Linux release 8.2 Beta (Ootpa)

# rpm -q fio
fio-3.7-3.el8.x86_64

# rpm -ql fio | grep LIC
/usr/share/doc/fio/MORAL-LICENSE

Now, whether users go looking for that file is another story.

Cheers,
Jeff


