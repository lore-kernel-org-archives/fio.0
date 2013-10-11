Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:42791 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756990Ab3JKQZy (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 11 Oct 2013 12:25:54 -0400
Message-ID: <52582654.9030001@kernel.dk>
Date: Fri, 11 Oct 2013 10:24:52 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] arch-ppc.h: Fix typo in header guard
References: <CAFFT=Unr67MfrDke4hrRztw5qZFBxkaV8HWOf+aTsCW5iWEsxw@mail.gmail.com>
In-Reply-To: <CAFFT=Unr67MfrDke4hrRztw5qZFBxkaV8HWOf+aTsCW5iWEsxw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Akash Verma <akashv@google.com>, fio <fio@vger.kernel.org>
Cc: Maria Skidanova <skidam@google.com>, Craig Fuget <cfuget@google.com>

On 10/10/2013 01:26 PM, Akash Verma wrote:
> Signed-off-by: Akash Verma <akashv@google.com>
> ---
>  arch/arch-ppc.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arch-ppc.h b/arch/arch-ppc.h
> index 6c1029c..8313331 100644
> --- a/arch/arch-ppc.h
> +++ b/arch/arch-ppc.h
> @@ -1,5 +1,5 @@
>  #ifndef ARCH_PPC_H
> -#define ARCH_PPH_H
> +#define ARCH_PPC_H

Woops thanks, applied.

-- 
Jens Axboe

