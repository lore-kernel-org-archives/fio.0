Return-Path: <fio-owner@vger.kernel.org>
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33757 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727020AbgKFSLU (ORCPT
        <rfc822;fio@vger.kernel.org>); Fri, 6 Nov 2020 13:11:20 -0500
Subject: Re: [PATCH] fix dynamic engine build
From: Eric Sandeen <sandeen@redhat.com>
References: <838bb7e7-3702-b2c4-641b-4d397aa6a94a@sandeen.net>
 <3329513a-9330-a96e-d410-1cf1576ef8d2@redhat.com>
Message-ID: <826e33ac-a2be-bf12-a36f-38380d37697f@redhat.com>
Date: Fri, 6 Nov 2020 12:11:16 -0600
MIME-Version: 1.0
In-Reply-To: <3329513a-9330-a96e-d410-1cf1576ef8d2@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>

On 11/6/20 11:41 AM, Eric Sandeen wrote:
> Builds with --dynamic-libengines are currently broken, because the rule
> to build the libraries was moved out of the template that creates them:
> 
> make: *** No rule to make target 'engines/libpmem.so', needed by 'all'.  Stop.
> make: *** Waiting for unfinished jobs....
> 
> Fix this by moving the rule back into the template, calling the template
> to create rules only after FIO_CFLAGS has been incorporated into CFLAGS,
> and using CFLAGS + -fPIC in that rule rather than FIO_CFLAGS.
> 
> Fixes: 8a2cf08d29ac ("Makefile: introduce FIO_CFLAGS")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> I think this is correct, but I would appreciate a review from Sitsofe.


NAK

breaks built-in engines.  Argh.


