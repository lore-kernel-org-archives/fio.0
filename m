Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f178.google.com ([209.85.217.178]:37848 "EHLO
        mail-ua0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965016AbeCGUTv (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Mar 2018 15:19:51 -0500
Received: by mail-ua0-f178.google.com with SMTP id q12so2339751uae.4
        for <fio@vger.kernel.org>; Wed, 07 Mar 2018 12:19:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKwzdDqj81MK7i63idBLUnm22pXO9bK_2P5b-o7=JOOvKjcKYw@mail.gmail.com>
References: <CAKwzdDrG3vgzMzttpZm4HgbziXUNsXiOgNP_PAty+KRasQ7szg@mail.gmail.com>
 <CALjAwxgH-QB_AUErVOu_zwWGLV-Zn1y1poOHXj0qQce_3tyCHw@mail.gmail.com>
 <CALjAwxjV5-GOzNpDHTJmMobyHExJD6Pkkpi=SBU04T=HQhHVLQ@mail.gmail.com>
 <CAKwzdDpwvgmWtCssGYNDv7BLgoPe56SqRCtFf_B0P1i9oR4fOw@mail.gmail.com>
 <CAKwzdDqbdDJqK-TKEss5H5+e0hiFns2Tv6Rj6hqHvxN7QBXPZA@mail.gmail.com>
 <CAKwzdDowpJ3FkUgySFJM1nE3YKP5Ru7c76KtNFBOA2wgHRWy+g@mail.gmail.com>
 <CALjAwxht9kUnEZPnjgE8nrFB6GhtJAUNX0JLobYw9ffTfYRB+g@mail.gmail.com>
 <CAKwzdDqOCQiQCFTYPd_tz9=DwvW+qNc=rTkW4Mu8yY8uL71fdg@mail.gmail.com>
 <CAKwzdDoFAARSxVQYLzBqqqeAJvGe4dkVjwsipP6zkSPc1rwyTw@mail.gmail.com>
 <CALjAwxiXQYQR6CVJjs6AukG=PGTqit3THSxCA3RSUFo6TbRCEA@mail.gmail.com>
 <CAKwzdDr2z-Z7YQK0GpSX_syvFDtdZ_Px7k5Fd1G0eaE12cy7_A@mail.gmail.com>
 <CALjAwxgRN3i+ZQq92yJa9NMfdfAxuBrxqHOQTbn_9L7SoFCYsQ@mail.gmail.com> <CAKwzdDqj81MK7i63idBLUnm22pXO9bK_2P5b-o7=JOOvKjcKYw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 7 Mar 2018 20:19:20 +0000
Message-ID: <CALjAwxia6L1SfuaZA4Vr_XrSJ9z7F6A1Xe=3p2zML0ADGaUstQ@mail.gmail.com>
Subject: Re: FIO size parameter feedback
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: abhishek koundal <akoundal@gmail.com>
Cc: fio <fio@vger.kernel.org>

I'd argue that by now someone will have started depending on the
rounding behaviour of a percentage size and someone else will be
depending on the non-rounding behaviour when its specified without
percentages so you'd need a strong reason to change. However
documenting this quirk would be helpful...

On 7 March 2018 at 19:07, abhishek koundal <akoundal@gmail.com> wrote:
> So do we say its how the tool has to behave? (surely with added documentation)
>
> On Wed, Mar 7, 2018 at 10:38 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>> I'd say it's something that could be better documented (size as
>> percentage rounds to the minimum blocksize) in the same way it's
>> already documented for offset percentages. The problem is if size
>> didn't do the rounding of percentages things would get tricky when you
>> start trying to cut disks up using offset and size (think offset=0%
>> size=25% then offset=25% size=25%). Plus you don't really want to do
>> rounding when the user specifies an exact amount/doesn't set anything
>> at all because you want to assume the user knows what they are
>> doing...

-- 
Sitsofe | http://sucs.org/~sits/
