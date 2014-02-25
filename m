Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:39303 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbaBYBvg (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 24 Feb 2014 20:51:36 -0500
Received: by mail-wi0-f178.google.com with SMTP id cc10so69855wib.17
        for <fio@vger.kernel.org>; Mon, 24 Feb 2014 17:51:35 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 24 Feb 2014 17:51:35 -0800
Message-ID: <CALKLVuJOou3sLCgnKyfpUaB52M_4L+Xq6_U7ft1YFss_B-+xoQ@mail.gmail.com>
Subject: numerical option parsing broken in engine options
From: Castor Fu <castor@egocast.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I was debugging some problems with parsing fio jobs, and found
options.c:fio_get_kb_base is broken for external engines... The
parameter
'data' is either 0, td, or td->eo.  If it's td->eo it's not really
going to work.

The cleaner fix is probably to unwind passing 'data' so far down the
stack, but it
touches a lot of functions, so I thought I'd send this out now.

unsigned int fio_get_kb_base(void *data)
{
        struct thread_options *o = data;
        unsigned int kb_base = 0;

        if (o)
                kb_base = o->kb_base;
        if (!kb_base)
                kb_base = 1024;

        return kb_base;
}


If I replace
   if(o)
by
     if (o && (data - (void *) threads) % sizeof(threads[0]) == 0)

then it behaves as I expect when engine options use the 'k', etc.

    -castor
