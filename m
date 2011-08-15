Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:53903 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab1HOHQK (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 15 Aug 2011 03:16:10 -0400
Message-ID: <4E48C7B6.80108@fusionio.com>
Date: Mon, 15 Aug 2011 09:16:06 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: [PATCH] stats: Add a function to report completion latency percentiles
References: <1313175153-5355-1-git-send-email-yjhong@google.com> <4E45AF96.4070606@kernel.dk> <CAC8teKW=oXw5LSsH_4rVdOtCkunoSEDo-jS_FUbVgFgjnrzzjw@mail.gmail.com> <4E48C2C1.60307@kernel.dk> <4E48C3D9.4020000@fusionio.com> <CAC8teKWCc1L_VfimnTXQkGaYtsL+BraKCTqfk+2S-see8T=UdQ@mail.gmail.com>
In-Reply-To: <CAC8teKWCc1L_VfimnTXQkGaYtsL+BraKCTqfk+2S-see8T=UdQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Zhu Yanhai <zhu.yanhai@gmail.com>
Cc: Yu-ju Hong <yjhong@google.com>, fio@vger.kernel.org, Nauman Rafique <nauman@google.com>, Eric Gouriou <egouriou@google.com>, Yu-Ju Hong <yuju.hong@gmail.com>

On 2011-08-15 09:15, Zhu Yanhai wrote:
> Yes, it works. The iops number is correct now.

Good, it works for me too. I have committed that fix. Thanks for
reporting! And testing.

-- 
Jens Axboe

