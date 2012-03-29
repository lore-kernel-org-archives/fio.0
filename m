Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43944 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759221Ab2C2S1r convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 29 Mar 2012 14:27:47 -0400
Received: by bkcik5 with SMTP id ik5so2280236bkc.19
        for <fio@vger.kernel.org>; Thu, 29 Mar 2012 11:27:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANWz5fhJWZzg21aXRbHiNwTBMOiTEqDmGYHD0iTybQPTWTaw8w@mail.gmail.com>
References: <CAKAYmM+szZDvUmba3T-sCm8EB-QQhE0xQBsiePCJ7LqNGCA2BQ@mail.gmail.com>
	<CANWz5fhJWZzg21aXRbHiNwTBMOiTEqDmGYHD0iTybQPTWTaw8w@mail.gmail.com>
Date: Thu, 29 Mar 2012 11:27:44 -0700
Message-ID: <CAKAYmM+a8Dsz0+_SgNchhW_ESto=zycq-_e_we7=LoZ9aPM9EQ@mail.gmail.com>
Subject: Re: odd result with iodepth
From: Chuck Tuffli <ctuffli@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

On Thu, Mar 29, 2012 at 10:14 AM, Chris Worley <worleys@gmail.com> wrote:
> Sequential merging? =EF=BF=BDTry "randread" instead.

Great suggestion. Doing some additional analysis, it does appear that
IO's are probably getting merged as I see individual IO requests on
the wire of 2-4KB.

Googling around this area seems to suggest this kernel behavior isn't
something I can disable. So if I honest to goodness *only* want 512B
IO, is ioengine=3Dsg the best route?

---chuck
