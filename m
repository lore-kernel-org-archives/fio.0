Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:37444 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbZDTBQo convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Sun, 19 Apr 2009 21:16:44 -0400
Received: by fxm2 with SMTP id 2so1720270fxm.37
        for <fio@vger.kernel.org>; Sun, 19 Apr 2009 18:16:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <m2eiw1fys9.fsf@gmail.com>
References: <m2eiw1fys9.fsf@gmail.com>
Date: Mon, 20 Apr 2009 03:16:42 +0200
Message-ID: <ed038eb20904191816u4994898fyeaaad97a9d6147ad@mail.gmail.com>
Subject: Re: question about fork_main()
From: Carl Henrik Lunde <chlunde@ping.uio.no>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: fio@vger.kernel.org

On Thu, Apr 9, 2009 at 20:49, Francis Moreau <francis.moro@gmail.com> wrote:
> hello,
>
> I just took a look to fio source code (great tool BTW), and I'm
> wondering about the fork_main() comment:
>
> /*
> =EF=BF=BD* We cannot pass the td data into a forked process, so attach th=
e td
> =EF=BF=BD* and pass it to the thread worker.
> =EF=BF=BD*/
>
> Since after a fork(2) the child inherits the attached shared memory
> segments from its parent, I don't see the point of this comment.
>
> Could anybody enlight me ?

I think your observation is correct, this is not necessary, shmat in
the child can be avoided.

>
> thanks.
> --
> Francis
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =EF=BF=BDhttp://vger.kernel.org/majordomo-info.html
>


--=20
mvh
Carl Henrik
