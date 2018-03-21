Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:53265 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751917AbeCURzU (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 21 Mar 2018 13:55:20 -0400
Received: by mail-it0-f41.google.com with SMTP id b136-v6so7962312iti.3
        for <fio@vger.kernel.org>; Wed, 21 Mar 2018 10:55:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKwzdDrOufV5HjdN3=+Hvr1vbnUrgM8U5G=9Wuk1Lh_kjAiFCw@mail.gmail.com>
References: <CAKwzdDrOufV5HjdN3=+Hvr1vbnUrgM8U5G=9Wuk1Lh_kjAiFCw@mail.gmail.com>
From: abhishek koundal <akoundal@gmail.com>
Date: Wed, 21 Mar 2018 10:54:39 -0700
Message-ID: <CAKwzdDqnZE_cEe61Hx-GCzTuc+MDwzpqD_JVwTZF4ky_znNnFA@mail.gmail.com>
Subject: Re: FIO latency bin midpoint vs upper limit capture
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Checking back if there is any feedback on the above request for
reporting max latency in the bins.
Appreciate the support.

On Wed, Mar 14, 2018 at 2:07 PM, abhishek koundal <akoundal@gmail.com> wrote:
> All,
> Currently the FIO latency  bins does the i/o count and but then as per
> Lower bound, midpoint (rounded off), upper limit
>
> The reported latency is the based on the "midpoint".
> Is there a way to report it based on the "upper limit"? e.g. compile
> fio with some switch etc.
>
> Appreciate your support always :).
>
> --
> Life is too short for silly things so invest your time in some
> productive outputs!!



-- 
Life is too short for silly things so invest your time in some
productive outputs!!
