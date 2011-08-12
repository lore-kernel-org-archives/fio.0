Return-Path: <fio-owner@vger.kernel.org>
Received: from [95.166.99.235] ([95.166.99.235]:54962 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab1HLW4b (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 12 Aug 2011 18:56:31 -0400
Message-ID: <4E45AF96.4070606@kernel.dk>
Date: Sat, 13 Aug 2011 00:56:22 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH]     stats: Add a function to report completion latency  percentiles
References: <1313175153-5355-1-git-send-email-yjhong@google.com>
In-Reply-To: <1313175153-5355-1-git-send-email-yjhong@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Yu-ju Hong <yjhong@google.com>
Cc: fio@vger.kernel.org, Nauman Rafique <nauman@google.com>, Eric Gouriou <egouriou@google.com>, Yu-Ju Hong <yuju.hong@gmail.com>

On 2011-08-12 20:52, Yu-ju Hong wrote:
>     This patch introduces two new options:
>     1) Specifying --clat_percentiles enables the reporting of
>        completion latency percentiles.
>     2) --percentile_list allows the user to customize the
>        list of percentiles to report.

Good feature, applied. The usage of done and !done for 'first' and
'curr' is a little odd, at least it could warrant a comment. But
otherwise looks good.

-- 
Jens Axboe

