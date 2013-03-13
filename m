Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vb0-f49.google.com ([209.85.212.49]:56262 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932593Ab3CMBMU (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 12 Mar 2013 21:12:20 -0400
Received: by mail-vb0-f49.google.com with SMTP id s24so213052vbi.36
        for <fio@vger.kernel.org>; Tue, 12 Mar 2013 18:12:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130312121508.GN25165@kernel.dk>
References: <513EB3E5.7020209@cse.unsw.edu.au>
	<20130312121508.GN25165@kernel.dk>
Date: Wed, 13 Mar 2013 12:12:19 +1100
Message-ID: <CAKCZDgnha9DywhkiFS4BOLGnva4G==hC0fZ-Cysn4-fBtzqOwA@mail.gmail.com>
Subject: Re: [PATCH] Android: add ioprio support
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org

On 12 March 2013 23:15, Jens Axboe <axboe@kernel.dk> wrote:
> On Tue, Mar 12 2013, Aaron Carroll wrote:
>> Also fix a build warning due to unused variable in some configs.
>
> I applied the ioprio part, is the other bit against an older series?

Er, yes. Sorry about that.


 -- Aaron
