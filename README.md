Signed
======
An iOS application to save, sign, and send documents on your iPhone. 

![First Screen Image](/Signed/ScreenShot1.png)

![Signature Image](/Signed/ScreenShot.png)



###Description

This iOS application was the product of my final project at Ironhack. For my project, I wanted to take on something that already had a market, but could be substantially improved. I wanted signatures that looked like real-life ones, and wanted the app to be simple without requiring the user to sign up. Most importantly, I wanted a technical challenge that was dependent on exclusively Apple APIs (excluding Facebook's POP Animations and a UIImage->PDF Cocoapod), so that all the interesting work had to come from my own development. 

==============

###Process
Along the way, I made attempts to practice clean architecture. The architecture is divided up into a few sections:
* Signature Maker (SignatureMaker, Line, UIBezierPath+Subline,  LineSmoothHelper)
* Document and Signature Models (Signature, Document, FileEntity)
* Utilities (DocumentManager, SignatureProcessManager, PDFWriter) 
* View Controllers (HistoryViewController, DetailViewController, SignatureViewController, AddSignatureViewController)
* Animators (SignButtonAnimator, ColorButtonAnimator)

While keeping in mind architectural patterns like MVC, MVVM, and VIPER, I felt that more logical architecture decisions required only loose adherence to those patterns.

==============


###Difficulties
Currently, this application leaks a lot of memory (from an update to my signature library), and produces PDFs which are far too large to reasonably send to someone. In the future, I intend to write a library that more clearly demonstrates how to safely mask an image onto a PDF, but for now, I am afraid this app will be collecting dust as I work on other projects.

I will end this by saying that CoreGraphics is my nemesis.

==============
