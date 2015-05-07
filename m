Return-Path: <bruce@cran.org.uk>
Message-ID: <554BEDB1.80805@cran.org.uk>
Date: Thu, 07 May 2015 16:56:49 -0600
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: [PATCH] Add Windows ctime_r implementation and empty ioctl.h
 header
References: <554ADC87.2070605@cran.org.uk> <554B99DD.2000902@kernel.dk> <554BD378.70209@cran.org.uk> <554BD3CE.6090609@kernel.dk> <554BD8A5.6040104@cran.org.uk> <554BD9E3.4040005@kernel.dk>
In-Reply-To: <554BD9E3.4040005@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------060004020700070004040404"
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------060004020700070004040404
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/2015 3:32 PM, Jens Axboe wrote:
> Honestly, that should just use PATH_MAX. I'll make that change instead 
> of adding this patch

Thanks.  And one last patch, to fix the Windows installer build this time.

-- 
Bruce

--------------060004020700070004040404
Content-Type: text/plain; charset=windows-1252;
 name="0001-Fix-Windows-installer-build-LICENSE-is-now-MORAL-LIC.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Fix-Windows-installer-build-LICENSE-is-now-MORAL-LIC.pa";
 filename*1="tch"

From 452f548cd17d13e6fe0047a82204f83202ea9fbe Mon Sep 17 00:00:00 2001
From: Bruce Cran <bruce.cran@gmail.com>
Date: Thu, 7 May 2015 16:54:37 -0600
Subject: [PATCH] Fix Windows installer build: LICENSE is now MORAL-LICENSE

---
 os/windows/install.wxs | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index ba58b92..f392606 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -40,7 +40,7 @@
 							<File Id="COPYING" Name="COPYING.txt" Source="..\..\COPYING"/>
 						</Component>
 						<Component>
-							<File Id="LICENSE" Name="LICENSE.txt" Source="..\..\LICENSE"/>
+							<File Id="MORAL_LICENSE" Name="MORAL-LICENSE.txt" Source="..\..\MORAL-LICENSE"/>
 						</Component>
 						<Directory Id="examples" Name="examples"/>
 					</Directory>
@@ -54,7 +54,7 @@
 		<ComponentRef Id="README"/>
 		<ComponentRef Id="REPORTING_BUGS"/>
 		<ComponentRef Id="COPYING"/>
-		<ComponentRef Id="LICENSE"/>
+		<ComponentRef Id="MORAL_LICENSE"/>
 		<ComponentGroupRef Id="examples"/>
 	</Feature>
 
-- 
1.9.5.msysgit.1


--------------060004020700070004040404--

