Return-Path: <fio-owner@vger.kernel.org>
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:40217 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726102AbgHaHeF (ORCPT
        <rfc822;fio@vger.kernel.org>); Mon, 31 Aug 2020 03:34:05 -0400
Date: Mon, 31 Aug 2020 09:33:55 +0200
From: Andreas Herrmann <aherrmann@suse.com>
Subject: Re: [PATCH 0/3] cgroup: Misc fixes
Message-ID: <20200831073355.GO6041@suselix>
References: <20200827120722.GC6041@suselix>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20200827120722.GC6041@suselix>
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: fio@vger.kernel.org

On Thu, Aug 27, 2020 at 02:07:25PM +0200, Andreas Herrmann wrote:
> Hi,
>=20
> I've tried fio's cgroup options with a recent kernel and found some
> issues with it -- following some patches to fix them.

Now I think patches #1 and #3 are superfluous or should be folded into
patches of my 2nd submission. I'll rework my patches.

--=20
Regards,
Andreas

SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer (HRB 36809, AG N=C3=BCrnberg)


