Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34631
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752379Ab3BRSqc (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 18 Feb 2013 13:46:32 -0500
Date: Mon, 18 Feb 2013 19:45:03 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: All I/O patterns are replayed to one file with fio 2.0.13
Message-ID: <20130218184503.GA26519@kernel.dk>
References: <511D3CDE.6070302@informatik.uni-rostock.de>
 <20130218135756.GQ6003@kernel.dk>
 <51224D3E.6020805@informatik.uni-rostock.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51224D3E.6020805@informatik.uni-rostock.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Nikolaus Jeremic <jeremic@informatik.uni-rostock.de>
Cc: fio@vger.kernel.org

On Mon, Feb 18 2013, Nikolaus Jeremic wrote:
> Index: fio-2.0.13/iolog.c
> ===================================================================
> --- fio-2.0.13/iolog.c    (revision 807)
> +++ fio-2.0.13/iolog.c    (revision 863)
> @@ -316,6 +316,7 @@
>                                      act);
>                  continue;
>              }
> +            fileno = get_fileno(td, fname);
>          } else if (r == 2) {
>              rw = DDIR_INVAL;
>              if (!strcmp(act, "add")) {

Thanks, applied!

-- 
Jens Axboe

