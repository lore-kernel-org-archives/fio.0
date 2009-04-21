Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:38923 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758154AbZDUShH convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 21 Apr 2009 14:37:07 -0400
Received: by fxm2 with SMTP id 2so2680964fxm.37
        for <fio@vger.kernel.org>; Tue, 21 Apr 2009 11:37:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ed038eb20904191816u4994898fyeaaad97a9d6147ad@mail.gmail.com>
References: <m2eiw1fys9.fsf@gmail.com>
	 <ed038eb20904191816u4994898fyeaaad97a9d6147ad@mail.gmail.com>
Date: Tue, 21 Apr 2009 20:37:04 +0200
Message-ID: <38b2ab8a0904211137v3369b1cdxf80ee66658284719@mail.gmail.com>
Subject: Re: question about fork_main()
From: Francis Moreau <francis.moro@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Carl Henrik Lunde <chlunde@ping.uio.no>
Cc: fio@vger.kernel.org

On Mon, Apr 20, 2009 at 3:16 AM, Carl Henrik Lunde <chlunde@ping.uio.no> wr=
ote:
> On Thu, Apr 9, 2009 at 20:49, Francis Moreau <francis.moro@gmail.com> wro=
te:
>> hello,
>>
>> I just took a look to fio source code (great tool BTW), and I'm
>> wondering about the fork_main() comment:
>>
>> /*
>> =EF=BF=BD* We cannot pass the td data into a forked process, so attach t=
he td
>> =EF=BF=BD* and pass it to the thread worker.
>> =EF=BF=BD*/
>>
>> Since after a fork(2) the child inherits the attached shared memory
>> segments from its parent, I don't see the point of this comment.
>>
>> Could anybody enlight me ?
>
> I think your observation is correct, this is not necessary, shmat in
> the child can be avoided.
>

Should I send a patch ?

thanks
--=20
Francis
