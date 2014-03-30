Return-Path: <fio-owner@vger.kernel.org>
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:58120 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaC3H6c (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 30 Mar 2014 03:58:32 -0400
Date: Sun, 30 Mar 2014 08:58:31 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: Asking a question
Message-ID: <20140330075829.GA1805@sucs.org>
References: <CA+MOiPYRpNDZ0-d2M9nDs1yjMogfEGg19ems9g_t23DNECXqLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+MOiPYRpNDZ0-d2M9nDs1yjMogfEGg19ems9g_t23DNECXqLA@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Nikhil Kekan <nikhil19kekan@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Nikhil,

On Sun, Mar 30, 2014 at 11:24:01AM +0530, Nikhil Kekan wrote:
>
> If i want to perform io operations on a particular storage device, how
> can i specify that in my jobfile? which option should i use?
> Also if i want to perform io operations on a file,how can i specify
> that in my job file?

In both cases you can use the filename parameter:
http://git.kernel.dk/?p=fio.git;a=blob;f=HOWTO#l268 .

-- 
Sitsofe | http://sucs.org/~sits/
