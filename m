Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37306 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab3EATcB (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 1 May 2013 15:32:01 -0400
Date: Wed, 1 May 2013 21:31:46 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: android ashmem patch [review request]
Message-ID: <20130501193146.GK7800@kernel.dk>
References: <372C7AE269BA5E4D92B1082F530ED4B85069DFC9@ORSMSX110.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <372C7AE269BA5E4D92B1082F530ED4B85069DFC9@ORSMSX110.amr.corp.intel.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Akers, Jason B" <jason.b.akers@intel.com>
Cc: "'fio@vger.kernel.org'" <fio@vger.kernel.org>

On Tue, Apr 30 2013, Akers, Jason B wrote:
> I wrapped the ashmem calls with the existing shm* function definitions. It's a little ugly, but makes for an easy patch touching only os/os-android.h.
> 
> Tested on both arm and x86 android phones.

Thanks, applied. Would be a smidgen better to add os/os-android.c and
put the functions in there. It is a little much code to put in a header.

-- 
Jens Axboe

