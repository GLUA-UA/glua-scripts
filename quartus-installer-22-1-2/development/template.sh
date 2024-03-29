#!/bin/bash

#
# DEFAULT VALUES FOR NON-INTERACTIVE INSTALL
#

HOME_DIR="/home/$USER"
INSTALL_PATH="/home/$USER/.intel_fpga_lite/22.1.2"

QUARTUS_ENABLE=true
QUARTUS_HELP_ENABLE=true
DEVINFO_ENABLE=true
ARRIA_LITE_ENABLE=true
CYCLONE_ENABLE=true
CYCLONE10LP_ENABLE=true
CYCLONEV_ENABLE=true
MAX_ENABLE=true
MAX10_ENABLE=true
QUARTUS_UPDATE_ENABLE=true
QUESTA_FSE_ENABLE=true
QUESTA_FE_ENABLE=false

#
# HELPER FUNCTIONS
#

check_script_deps() {
    echo -n "Checking script dependencies..."
    has_wget=$(command -v wget)
    has_tar=$(command -v tar)
    has_whiptail=$(command -v whiptail)
    if [[ -z "$has_wget" || -z "$has_tar" || -z "$has_whiptail" ]]; then
        echo -n "\nMissing dependencies. Please install"
        if [[ -z "$has_wget" ]]; then
            echo -n " wget"
        fi
        if [[ -z "$has_tar" ]]; then
            echo -n " tar"
        fi
        if [[ -z "$has_whiptail" ]]; then
            echo -n " whiptail"
        fi
        echo " and try again."
        exit 1
    fi
    echo " Dependencies OK"
}

build_disabled_components_flag() {
    DISABLED_COMPONENTS_FLAG=""
    [ $QUARTUS_ENABLE == false ] && DISABLED_COMPONENTS_FLAG="${DISABLED_COMPONENTS_FLAG}quartus,"
    [ $QUARTUS_HELP_ENABLE == false ] && DISABLED_COMPONENTS_FLAG="${DISABLED_COMPONENTS_FLAG}quartus_help,"
    [ $DEVINFO_ENABLE == false ] && DISABLED_COMPONENTS_FLAG="${DISABLED_COMPONENTS_FLAG}devinfo,"
    [ $ARRIA_LITE_ENABLE == false ] && DISABLED_COMPONENTS_FLAG="${DISABLED_COMPONENTS_FLAG}arria_lite,"
    [ $CYCLONE_ENABLE == false ] && DISABLED_COMPONENTS_FLAG="${DISABLED_COMPONENTS_FLAG}cyclone,"
    [ $CYCLONE10LP_ENABLE == false ] && DISABLED_COMPONENTS_FLAG="${DISABLED_COMPONENTS_FLAG}cyclone10lp,"
    [ $CYCLONEV_ENABLE == false ] && DISABLED_COMPONENTS_FLAG="${DISABLED_COMPONENTS_FLAG}cyclonev,"
    [ $MAX_ENABLE == false ] && DISABLED_COMPONENTS_FLAG="${DISABLED_COMPONENTS_FLAG}max,"
    [ $MAX10_ENABLE == false ] && DISABLED_COMPONENTS_FLAG="${DISABLED_COMPONENTS_FLAG}max10,"
    [ $QUARTUS_UPDATE_ENABLE == false ] && DISABLED_COMPONENTS_FLAG="${DISABLED_COMPONENTS_FLAG}quartus_update,"
    [ $QUESTA_FSE_ENABLE == false ] && DISABLED_COMPONENTS_FLAG="${DISABLED_COMPONENTS_FLAG}questa_fse,"
    [ $QUESTA_FE_ENABLE == false ] && DISABLED_COMPONENTS_FLAG="${DISABLED_COMPONENTS_FLAG}questa_fe,"
    DISABLED_COMPONENTS_FLAG=${DISABLED_COMPONENTS_FLAG%,}
    [ ! -z $DISABLED_COMPONENTS_FLAG ] && DISABLED_COMPONENTS_FLAG="--disable-components $DISABLED_COMPONENTS_FLAG"
    echo $DISABLED_COMPONENTS_FLAG
}

#
# INSTALLER FUNCTIONS
#

agreements() {
    export NEWT_COLORS='root=,blue'
    if (! whiptail --title "Quartus Prime Lite Installer" --yesno "This installer isn't affiliated with Intel Corporation and is provided\nwithout warranty of any kind. All trademarks are the property of their\n respective owners. Use of the software constitutes acceptance of the\n    terms of the Quartus Prime Lite Software License Agreement.\n\n      Intel Quartus Prime Lite 22.1.2 will be installed. Proceed?" 12 74); then
        whiptail --title "Quartus Prime Lite Installer" --msgbox "                 Installation aborted by user request." 7 75
        exit 1
    fi

    t=$(mktemp); echo $"
    QUARTUS PRIME AND INTEL FPGA IP LICENSE AGREEMENT, VERSION 22.1std

Intel, Quartus and the Intel logos are trademarks of Intel Corporation or its subsidiaries in the US and other countries. Any other trademarks and trade names referenced here are the property of their respective owners.

DO NOT DOWNLOAD, INSTALL, ACCESS, COPY, OR USE ANY PORTION OF THE LICENSED SOFTWARE UNTIL YOU HAVE READ AND ACCEPTED THE TERMS AND CONDITIONS OF THIS AGREEMENT. BY INSTALLING, COPYING, ACCESSING, OR USING THE LICENSED SOFTWARE, YOU AGREE TO BE LEGALLY BOUND BY THE TERMS AND CONDITIONS OF THIS AGREEMENT. If You do not agree to be bound by, or the entity for whose benefit You act has not authorized You to accept, these terms and conditions, do not install, access, copy, or Use the Licensed Software and destroy all copies of the Licensed Software in Your possession.

This Quartus Prime and Intel FPGA IP License Agreement (this "Agreement") is entered into between Intel Corporation, a Delaware corporation with a place of business at 2200 Mission College Blvd., Santa Clara, CA 95052, on behalf of itself and its wholly-owned subsidiaries, ("Intel") and You. "You" refers to you or your employer or other entity for whose benefit you act, as applicable. If you are agreeing to the terms and conditions of this Agreement on behalf of a company or other legal entity, you represent and warrant that you have the legal authority to bind that legal entity to the Agreement, in which case, "You" or "Your" will be in reference to such entity. Intel and You are referred to herein individually as a "Party" or, together, as the "Parties".

IN THE EVENT OF ANY INCONSISTENCY BETWEEN THE TERMS OF THIS AGREEMENT AND YOUR AGREEMENT WITH AN AUTHORIZED DISTRIBUTOR, THIS AGREEMENT WILL GOVERN AND CONTROL, EXCEPT WITH REGARDS TO PAYMENT TERMS.

1. Definitions.

1.1. "Authorized Contractors" means a person, company, or other entity that: (i) provides design, testing, or integration services for You, provided such integration services will be performed solely for implementation within Devices; and (ii) is subject to a written confidentiality agreement protecting Intel's Confidential Information with restrictions no less restrictive than those contained in this Agreement.

1.2. "Authorized Distributor" means a reseller, OEM, ODM, cloud platform provider, or any distributor or reseller that is authorized through a written agreement with Intel to license the Licensed Software to end users.

1.3. "Checkout License" means a time-limited license granted by Intel associated with an existing Floating Node Seat to install and Use the Licensed Software on a single fixed standalone computer for use by a single User. The total number of Checkout Licenses that may be granted in relation to a single Floating Node Seat may not exceed the total number of individual Seats associated with such Floating Node Seat.

1.4. "Concurrent Users" means the number of simultaneous Users accessing the Licensed Software.

1.5. "Confidential Information" means and includes, but is not limited to: (i) the Licensed Software and the algorithms, concepts, techniques, methods, and processes embodied therein; (ii) the Licensed Products and all information and Specifications associated therewith; (iii) any business, marketing, technical, scientific or financial information disclosed to You by Intel or an Authorized Distributor; or (iv) any information which, at the time of disclosure, is designated in writing as confidential or proprietary, or similar designation, is disclosed in circumstances of confidence, or would be reasonably understood by a person, exercising business judgment, to be confidential.

1.6. "Derivative Works" means a derivative work, as defined in 17 U.S.C. ? 101.

1.7. "Designated Equipment" means the computer system identified by a network interface card or host ID number on which the Licensed Software is installed and Used, and which has the configuration, capacity, operating system version level, and pre-requisite applications described in the Documentation as necessary for the operation of the Licensed Software, and is designated by the network interface card or host ID in the License Key as the computer system on which the License Key management software will be installed.

1.8. "Devices" means Intel FPGA's or Intel complex programmable logic devices.

1.9. "Documentation" means Intel-provided technical data (including, but not limited to manuals, release notes, advisories, etc.) which: (i) provides operating instructions for using or (ii) explains the capabilities and functions of the Licensed Software.

1.10. "Encryption Technology" means the encryption software technology created by Intel specifically for use with the Licensed Software and delivered along with the Licensed Software.

1.11. "Feedback" means materials, information, comments, suggestions, other communication regarding the features, functions, performance or use of the Licensed Software

1.12. "Fixed with Companion License" means a license to install: (i) the Licensed Software on a fixed standalone computer for use by a single User, and (ii) the Licensed Software on up to two companion fixed standalone computers. Under this license, only one Seat may be Used by a single User at any given time.

1.13. "Floating Node Seat" is a license that allows the Licensed Software to be: (i) installed on and accessed from any number of computers on a network environment; (ii) Used by the permitted number of Concurrent Users that is equal to the number of Seats licensed as determined by the License Key.

1.14. "FPGA" means a field programmable gate array.

1.15. "Infringement Claim" has the meaning ascribed to it in Section 7.1.

1.16. "Intel FPGA IP" means one or more design files, including encrypted netlists, RTL, test vectors, simulation models (such as VHDL, Verilog HDL, Quartus simulation, Matlab, Simulink, Verisity, Specman, Synopsys, and Vera) and other models, each of which may be provided in unencrypted source code, object code, encrypted netlist or encrypted source code formats, and memory controllers provided in source code format, where each is designed to implement or supports the design of a specific function into a Device, in the form delivered to You by Intel, including any subsequent upgrades or updates delivered to You by Intel.

1.17. "Intel FPGA IP Permitted Derivative Work" means a Derivative Work created by You of any Intel FPGA IP which has been provided to You in unencrypted source code format, and is permitted by Section 2.

1.18. "Intellectual Property Rights" means all (i) patents, patent applications, patent disclosures and inventions (whether patentable or not); (ii) trademarks, service marks, trade dress, trade names, logos, corporate names, Internet domain names, and registrations and applications for the registration for any of them, together with all goodwill associated with any of them; (iii) copyrights and copyrightable works (including computer programs and mask works) and registrations and applications for registration; (iv) trade secrets, know-how and other Confidential Information; (v) waivable or assignable rights of publicity, waivable or assignable moral rights; (vi) unregistered and registered design rights and any applications for registration; (vii) database rights and all other forms of intellectual property, such as data; and (viii) any and all similar or equivalent rights throughout the world.

1.19. "Intended Purpose" has the meaning ascribed to it in Section 5.

1.20. "License Fee" means the fee payable by You to Intel or an Authorized Distributor as described in a quote (or similar document) in consideration of the rights and licenses to the Licensed Software granted to You.

1.21. "License Key" means a FlexNet license key, license file, license manager, dongle or other key, code or information provided by Intel that: (i) enables a User to download, install, operate and/or regulate User access to the Licensed Software; (ii) indicates the expiration date for the license period for the Licensed Software; and (iii) lists the number of Concurrent Users authorized to Use the Licensed Software.

1.22. "Licensed Product" means any Device (i) which You or an Authorized Contractor have designed pursuant to the license grants to Quartus Prime in Section 2, and/or (ii) in which You or an Authorized Contractor have implemented or programmed Intel FPGA IP pursuant to the license grants to Intel FPGA IP in Section 2.

1.23. "Licensed Software" means the version(s) of (i) Quartus Prime and/or (ii) Intel FPGA IP(s) enabled for You via the License Key. Licensed Software does not include Unlicensed Software or Third Party Materials.

1.24. "NDA" has the meaning ascribed to it in Section 5.

1.25. "Open Source Software" means any software that requires as a condition of use, modification and/or distribution of such software that such software or other software incorporated into, derived from or distributed with such software: (a) be disclosed or distributed in source code form; (b) be licensed for the purpose of making Derivative Works; and (c) be redistributable at no charge. Open Source Software includes, without limitation, software licensed or distributed under any of the following licenses or distribution models, or licenses or distribution models similar to any of the following: (i) GNU's General Public License (GPL) or Lesser/Library GPL (LGPL); (ii) the Artistic License (e.g., PERL); (iii) the Mozilla Public License; (iv) the Netscape Public License; (v) the Sun Community Source License (SCSL); (vi) the Sun Industry Source License (SISL); and (vii) the Common Public License (CPL). The Open Source Software components associated with the Licensed Software and their corresponding license terms may be found in one or more of: (A) text files associated with the Licensed Software; (B) within the source code of the Licensed Software; or (C) within the source code of the Open Source Software that is provided with the Licensed Software.

1.26. "Quartus Prime" means the Quartus Software Suite(R), in the form delivered to You by Intel, including any subsequent upgrades or updates delivered to You by Intel.

1.27. "Seat" means the right to Use the Licensed Software by a single User. A Seat is either a Floating Node Seat, Checkout License, or a Fixed with Companion License, which is enabled via a License Key.

1.28. "Specification" means technical data in human or machine readable form furnished by Intel which: (i) provides operating instructions for using the Licensed Software, or (ii) explains the capabilities and functions of such items, and any full or partial copies of any such technical data.

1.29. "Standard" means a technology specification created by a government sponsored group, an industry sponsored group, or any similar group or entity that creates technology specifications to be used by others. Examples of Standards include GSM, LTE, 5G, Wi-Fi, CDMA, MPEG, and HTML. Examples of groups that create Standards include IEEE, ITU, 3GPP, and ETSI.

1.30. "Support" means any support or maintenance services provided to You by Intel, an Authorized Distributor, and/or authorized Intel representatives in responding to email, telephone, or other inquiries from You for maintenance, technical, or other support requests in connection with the Licensed Software.

1.31. "Third Party License" means a separate license file, header, or release note that contain additional terms, conditions or restrictions imposed by Third Party Licensors.

1.32. "Third Party Licensors" means any third party that licenses or provides Third Party Materials to Intel.

1.33. "Third Party Materials" means materials or components included in the download with the Licensed Software, including but not limited to, software, code portions or files, which are owned by Third Party Licensors, and are provided subject to Third Party Licenses.

1.34. "Unlicensed Software" means any Intel computer programs or code in any format for which You do not hold an active License Key issued by Intel, including but not limited to any non-subscribed or disabled features accompanying the Licensed Software.

1.35. "Use" means downloading, installing and/or copying all or any portion of the Licensed Software into the Designated Equipment for processing the instructions contained in the Licensed Software, and/or loading data into or displaying, viewing or extracting output results from, or otherwise operating, any portion of the Licensed Software.

1.36. "User" means each individual identified by You as a person authorized to Use the Licensed Software on behalf of and for Your benefit, including Your employees and Your Authorized Contractors.

2. Licenses and Restrictions.

2.1. Your License. Conditioned on Your compliance with the terms and conditions of this Agreement, including payment of any applicable License Fee, Intel grants to You a limited, nonexclusive, nontransferable, worldwide, fully paid-up license during the term of this Agreement under Intel's copyrights:

(i) in Quartus Prime,

a. to Use Quartus Prime to create, simulate, verify, place and route, and program designs on Devices, and

b. to manufacture or have manufactured, market, offer for sale, sell, or otherwise distribute or have distributed Licensed Products within Your products; and

(ii) in Intel FPGA IP,

a. to Use the Intel FPGA IP to design with, parameterize, compile, place and route, and generate programming files and netlists, solely for implementation in Devices,

b. to modify and create Derivative Works of any Intel FPGA IP which is provided to You in unencrypted source code format in order to create Intel FPGA IP Permitted Derivative Works,

c. to program and incorporate the Intel FPGA IP in Devices,

d. to manufacture or have manufactured, market, offer for sale, sell, or otherwise distribute or have distributed Licensed Products within Your products, and,

e. subject to Intel's prior written approval, and upon the negotiation of a mutually acceptable agreement and Your payment to Intel of additional license fees and/or royalties, to incorporate Intel FPGA IP within an approved ASIC for a specific project.

2.2. Use Restrictions. Except as expressly permitted under this Agreement, the following restrictions apply to Your use of the Licensed Software:

2.2.1. Your Use of the Licensed Software is restricted to any use, license or other restrictions agreed to at the time of Your order of the License Software (for example but not limited to, quantity, duration, number of instantiations and customers). 2.2.2. You may only use the Licensed Software in accordance with the Documentation, including all restrictions on use which may be placed in the release notes, advisories, and manuals. 2.2.3. You may not use, copy, modify, distribute, or otherwise transfer the Licensed Software or any portions thereof, or permit any remote access thereof by any person or entity. 2.2.4. You may not modify or synthesize any simulation model output generated from or resulting from the Licensed Software. 2.2.5. You may not sublicense or transfer the Licensed Software or any rights granted to You under this Agreement. 2.2.6. No right is granted under this Agreement to Use the Licensed Software (including any machine-executable, binary resulting from Use of the Licensed Software) to design, develop, incorporate in, or program any devices other than Devices. 2.2.7. You may not decompile, disassemble, reverse engineer, or otherwise attempt to access the source code of the Licensed Software or reduce it to a human readable form except as otherwise permitted by applicable law. 2.2.8. You may not publish or disclose the results of any benchmarking or testing of the Licensed Software or use such results for Your own software development activities, without the prior written permission of Intel. 2.2.9. If You have obtained the Licensed Software through the Intel FPGA University Program, then You are only permitted to Use the Licensed Software for educational and academic purposes and cannot Use the Licensed Software for any commercial purposes. 2.2.10. If You are using Intel FPGA IP pursuant to the Intel FPGA Evaluation Mode, Your license is more limited than the license granted by Intel in Section 2 of this Agreement. In the Intel FPGA Evaluation Mode You may only (i) evaluate the logic designs of Devices by performing the following functions: design entry, timing, place and route, compilation and verification of logic designs for Devices; and (ii) evaluate the hardware in Devices by programming the Intel FPGA IP into such Devices, but only for so long as the Devices are continuously connected via a programming cable to a host development computer that is running the Intel development tool programmer software. In the Intel FPGA Evaluation Mode, (i) the Intel FPGA IP will operate for a predetermined amount of time, after which the Intel FPGA IP will be automatically disabled and will be inoperable, and (ii) certain features and functions of the Intel FPGA IP may be disabled by Intel. In no event will Intel be held liable for any damages or losses to You or any third party resulting from the automatic disabling of any Intel FPGA IP during Use in the Intel FPGA Evaluation Mode.

2.3. Delivery and License Key. The Licensed Software will be delivered electronically and will be deemed accepted upon delivery. In accordance with its distribution method, Intel may include with the Licensed Software additional Unlicensed Software to which the License Key will not permit access. Inclusion of such Unlicensed Software in no way implies a license from Intel to access or Use such Unlicensed Software, and You agree not to access or Use such Unlicensed Software.

2.4. Designated Equipment. In order to generate License Keys, You must provide Intel with the Designated Equipment's host identification number, which Intel will include in the applicable License Key. You may change the Designated Equipment as permitted by the customer self- service license center, with further changes permitted only upon consent of Intel. Whenever You receive a new License Key in order to effect a transfer to new Designated Equipment, You will immediately cease to Use the Licensed Software under the previously issued License Key. You acknowledge and agree that You will not operate more than the number of Seats of the Licensed Software associated with Your License Key.

2.5. Floating Node Seat. If You have purchased a Floating Node Seat, You may also copy the Licensed Software onto another computer (or access it through networked workstations) for Use by another User; provided however, that all Users agree to accept the terms and conditions of this Agreement in writing prior to Using the Licensed Software.

2.6. Authorized Contractors. You may permit Authorized Contractors to perform services on Your behalf solely under the licenses granted to You in Section 2. You agree that all access to or Use of the Licensed Software by an Authorized Contractor is subject to the following: (i) such access and/or Use will be for Your sole benefit; (ii) a breach of this Agreement or the terms of any other Intel agreement by the Authorized Contractor will be deemed to be a breach of such agreement(s) by You, and You will be liable for any such breaches by the Authorized Contractor and will indemnify Intel for any damages suffered by Intel as a result of such breaches; and (iii) You will ensure that in no event will any such Authorized Contractor be a competitor of Intel for Devices.

2.7. Third Party Materials.

2.7.1. Third Party Materials may be provided in the download for use with the Licensed Software. The Third Party Materials are licensed to You pursuant to the terms of the applicable Third Party License. The Third Party Materials and Third Party Licenses are identified either in the documentation accompanying the Licensed Software, hyperlinks included with this Agreement or Readme files included with the Licensed Software. You agree to carefully review and fully comply with the terms of such Third Party Licenses.

2.7.2. Third Party Materials Disclaimer. NOTWITHSTANDING ANYTHING TO THE CONTRARY IN THE AGREEMENT, AS BETWEEN YOU AND INTEL, AND TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, ALL THIRD PARTY LICENSES WILL BE SUBJECT TO SECTION 6.2 (DISCLAIMER OF WARRANTIES); SECTION 10 (LIMITATION OF LIABILITY); AND SECTION 11 (CHOICE OF LAW/VENUE). INTEL OFFERS NO WARRANTIES (WHETHER EXPRESS OR IMPLIED); INDEMNIFICATION; AND/OR SUPPORT OF ANY KIND WITH RESPECT TO THIRD PARTY MATERIALS, EXCEPT THAT INTEL WILL PASS THROUGH TO YOU, IF AND TO THE EXTENT AVAILABLE, ANY WARRANTIES EXPRESSLY PROVIDED TO INTEL BY THIRD PARTY LICENSORS RELATING TO SUCH THIRD PARTY MATERIALS.

2.8. Open Source Statement. The Licensed Software may include Open Source Software licensed pursuant to an Open Source Software license agreement(s) identified in in the applicable source code file(s) or file header(s) provided with or otherwise associated with the Licensed Software. Neither You, nor any OEM, ODM, customer, or distributor may subject any proprietary portion of the Licensed Software to any Open Source Software license obligations including, without limitation, combining or distributing the Licensed Software with Open Source Software in a manner that subjects Intel, the Licensed Software or any portion thereof to any Open Source Software license obligation. Nothing in this Agreement limits any rights under, or grants rights that supersede, the terms of any applicable Open Source Software license.

2.9. Intellectual Property Rights Notices. Any copies of the Licensed Software made by or for You must include all Intellectual Property Rights notices. You will not, and will cause Your Authorized Contractors and Your customers and/or end users not to, remove any Intel Intellectual Property Rights notices or other proprietary markings from the Licensed Software. Any copy of the Licensed Software or portions thereof, including but not limited to any modified versions, Derivative Works, any portion merged into a design, and/or any design or product that incorporates all or any portion of the Licensed Software, will continue to be subject to the terms and conditions of this Agreement.

2.10. Feedback. This Agreement does not obligate You to provide Intel with Feedback. To the extent You provide Intel with Feedback in a tangible form, You grant to Intel and its affiliates a non-exclusive, perpetual, sublicenseable, irrevocable, worldwide, royalty-free, fully paid-up and transferable license, to and under all of Your intellectual property rights, whether perfected or not, to publicly perform, publicly display, reproduce, use, make, have made, sell, offer for sale, sublicense, distribute, import, create Derivative Works of and otherwise exploit any comments, suggestions, descriptions, ideas or other feedback regarding the Licensed Software provided by You or on Your behalf.

2.11. No Other Licenses or Intellectual Property Rights. Except as provided in this Agreement, neither party grants to the other party, either directly or indirectly, by implication, or by way of estoppel, any license or any other rights under such party's Intellectual Property Rights. Other than the rights expressly granted to You under the Agreement, Intel expressly reserves all other rights in and to the Licensed Software, Documentation, and Intellectual Property Rights associated with any of the foregoing. You acknowledge and agree that this Agreement does not grant You any right to practice, or any other rights with respect to, any patent of Intel or its licensors.

3. Ownership and Future Development.

3.1. Ownership of Licensed Software. All right, title and interest in and to the Licensed Software and associated Documentation are and will remain the exclusive property of Intel and its licensors or suppliers, including but not limited to enhancements, corrections, improvements, modified versions, or Derivative Works of all the foregoing, in whole or in part, whether developed or co-developed by Intel, or developed or co-developed by You pursuant to this Agreement. Notwithstanding anything to the contrary above in this Section, You will own all right, title and interest in any Intel FPGA IP Permitted Derivative Works created by You under this Agreement, and You may use and distribute any Intel FPGA IP Permitted Derivative Works, but agree to solely use and distribute Intel FPGA IP Permitted Derivative Works only for use in Devices. You grant to Intel and its affiliates a non- exclusive, perpetual, sublicenseable, irrevocable, worldwide, royalty- free, fully paid-up and transferable license, to and under all of Your Intellectual Property Rights, whether perfected or not, to publicly perform, publicly display, reproduce, use, make, have made, sell, offer for sale, sublicense, distribute, import, create Derivative Works of and otherwise exploit any of Your Intel FPGA IP Permitted Derivative Works.

3.2. You recognize and acknowledge that Intel is or may be independently developing for commercial use products that may be complementary to or competitive with Your products and may in the future independently develop products that may compete with Your products. Nothing in this Agreement will limit Intel's independent development and marketing or distribution of any products or systems, provided such independent development is accomplished without use of Your confidential information. The existence of this Agreement will not prevent Intel from undertaking discussions with third parties, including Your competitors.

4. Fees and Taxes

4.1. License Fee. You will pay Intel (or an Authorized Distributor) the License Fees in the amounts and at the times set forth in the applicable quote or invoice. Your obligation to remit License Fees in accordance with the applicable quote or invoice is absolute, unconditional, noncancellable and nonrefundable, and will not be subject to any abatement, set-off, claim, counterclaim, adjustment, reduction, or defense for any reason including, but not limited to, any claim that Intel failed to perform under this Agreement or termination of this Agreement. Past due amounts will bear interest at the rate of the lesser of 1-1/2% per month on the unpaid balance, or the maximum rate allowable by law. In addition to all other sums payable under this Agreement, You will pay all out-of-pocket expenses that Intel or an Authorized Distributor incurs, including fees and disbursements of counsel, in connection with collection and other enforcement proceedings resulting from or in connection with those proceedings.

4.2. Taxes. All payments will be made free and clear without deduction for any present and future taxes imposed by any taxing authority. If You are prohibited by law from making such payments unless You deduct or withhold taxes from the payments and remit the taxes to the local taxing jurisdiction, then You must withhold and remit those taxes and pay to Intel the remaining net amount after the taxes have been withheld. You will promptly furnish Intel with a copy of an official tax receipt or other appropriate evidence of any taxes imposed on payments made under this Agreement, including taxes on any additional amounts paid. In cases other than taxes referred to above including, but not limited to, sales and use taxes, stamp taxes, value added taxes, property taxes and other taxes or duties imposed by any taxing authority on or with respect to this Agreement, You will bear the costs of those taxes or duties. If those taxes or duties are legally imposed initially on Intel or Intel is later assessed by any taxing authority, then You will promptly reimburse Intel for those taxes or duties plus any interest and penalties that Intel suffers.

5. Confidentiality and Publicity.

5.1. With respect to Confidential Information, You agree to: maintain the confidentiality of the Confidential Information with at least the same degree of care that You use to protect Your own confidential and proprietary information, but no less than a reasonable degree of care under the circumstances; not to use or disclose Confidential Information for any purpose except to the extent necessary and for the purpose of exercising Your rights under this Agreement (the "Intended Purpose"); to restrict the disclosure and possession of Confidential Information solely to those Users, employees and Authorized Contractors with a need to know/need to access for the Intended Purpose, who agree to be bound by written confidentiality agreements no less strict than those contained in this Agreement; and be liable to Intel for any breaches of the confidentiality obligations by Your Users, employees, and Authorized Contractors. You will not be liable for the disclosure of any Confidential Information that is: generally made available publicly or to third parties by the disclosing party without restriction on disclosure; received without any obligation of confidentiality from a third party who rightfully had possession of the information; rightfully known to You without any limitation on disclosure, before Your receipt from the disclosing party; the same as information that is independently developed by employees, contingent workers, or professional advisers of Yours; or required to be disclosed under applicable laws, regulations, or court, judicial, or government agency orders. The receiving party must give the disclosing party reasonable notice before this disclosure, and seek a protective order, confidential treatment, or other remedy, if available, to limit the scope of the required disclosure. Information exchanged between Intel and You may additionally be subject to the terms and conditions of the Corporate Non-Disclosure Agreement(s) or Intel Pre-Release Loan Agreement(s) (referred to herein collectively or individually as "NDA") entered into by and in force between Intel and You. In the event of a conflict between this Agreement and the NDA, the NDA will control. You agree that Intel may disclose Your identity by name, address and other contact information, and identify the Licensed Software licensed to You, to the extent required by Intel's agreements with its licensors and Authorized Distributors.

5.2. You agree not to use Intel's name, trademarks or logos in any publications, advertisements, or other announcements without Intel's prior written consent.

6. Warranty Information

6.1. Limited Warranty. If the Licensed Software has been delivered on physical media, Intel warrants for 90 days after delivery that the media on which the Licensed Software is furnished is free of manufacturing defects and shipping damage provided the media has been properly installed. Intel does not warrant that the Licensed Software will meet Your requirements or that the use will be uninterrupted or error-free. Your sole remedy and Intel's entire liability for breach of the warranty in this Section, is that You may return the defective media to Intel for replacement or alternate delivery, at Intel's option and expense. This warranty is void if the media defect has resulted from accident, abuse, mishandling, misuse, misinstallation, neglect or misapplication.

6.2. Disclaimer of Warranties. Except as provided above, Intel makes no warranties to You with respect to the Licensed Software, Third Party Materials, Open Source Software or any Support, service, advice, or assistance furnished under this Agreement, and no warranties of any kind, whether written, oral, implied or statutory, including warranties of merchantability or fitness for a particular purpose, non-infringement or arising from course of dealing or usage in trade will apply.

6.3. Encryption Technology. The Licensed Software may include Encryption Technology. The Encryption Technology is based on both recognized industry encryption technology standards and proprietary Intel technology. The Encryption Technology is provided solely for Your convenience in using the Licensed Software under this Agreement. You recognize and agree that no encryption software is error-free, foolproof or completely secure (including the Encryption Technology) and as such You agree that the Encryption Technology is provided "as is" with no warranties of any kind, whether written, oral, implied or statutory, including warranties of merchantability, fitness for a particular purpose, non-infringement or arising from course of dealing or usage in trade. You agree that Your use of the Encryption Technology is at Your own risk and that Intel will not be liable for any claims related to Your use of the Encryption Technology.

6.4. Third Party Actions; Security Threats. Intel makes no warranty with respect to any malfunctions or other errors in its hardware products or software products caused by virus, infection, worm or similar malicious code not developed or introduced by Intel. Intel makes no warranty that any hardware products or software products will protect against all possible security threats, including intentional misconduct by third parties. Intel is not liable for any downtime or service interruption, for any lost or stolen data or systems, or for any other damages arising out of or relating to any such actions or intrusions.

7. Indemnification.

7.1. Intel will defend, at its own expense, any legal action brought against You to the extent that it is based on any claim or allegation that the Licensed Software, in the form delivered to You, directly infringes a U.S. patent or copyright or constitutes a misappropriation of trade secrets of any third party ("Infringement Claim").

7.2. Intel will pay any costs and damages finally awarded against You in any Infringement Claim that are attributable to the Infringement Claim or that You incur through settlement of the Infringement Claim, but will not be responsible for any compromise that You made or expense that You incurred without Intel's written consent.

7.3. Notwithstanding anything else in the Agreement, Intel will not indemnify or defend You for claims asserted, in whole or part, against: (i) technology or designs that You gave to Intel; (ii) failure to use compatible devices (including Intel Devices) as set forth in the Specifications; (iii) modifications or programming to the Licensed Software that were made by anyone other than Intel; or, (iv) the Licensed Software's alleged implementation of some or all of a Standard.

7.4. The defense and payment obligations of Intel in this Section 7 are subject to the condition that You: (i) give Intel prompt written notice of the Infringement Claim; (ii) allow Intel to direct the defense and settlement of the Infringement Claim; and (iii) cooperate with Intel in the defense and settlement of the Infringement Claim.

7.5. This indemnity is personal to You and will under no circumstances be assignable, transferable or subject to pass-through to Your customers or indirect customers. You will notify customers that they must look solely to You in connection with any Infringement Claim.

7.6. If any Licensed Software, or the operation of the Licensed Software, becomes or, in Intel's opinion is likely to become, the subject of an Infringement Claim, Intel may, at Intel's option and expense, procure for You the right to continue using the Licensed Software, replace or modify the Licensed Software so that it becomes non-infringing, or terminate the license granted under this Agreement for that Licensed Software and refund to You the License Fees You paid to Intel (less a reasonable charge for the period during which You has had availability of that Licensed Software for use, and of Support). This Section 7 will survive for three (3) years after expiration or termination of this Agreement.

8. Term and Termination.

8.1. Term. This Agreement is effective until terminated by either party, or terminated in accordance with its terms, whichever occurs first.

8.2. Termination. Intel may terminate this Agreement in accordance with its terms. You may terminate this Agreement at any time by uninstalling and permanently ceasing Use of the Licensed Software. Intel may terminate the license immediately if You or an Authorized Contractor fail to comply with any material term or condition of this Agreement, including but not limited to Your or an Authorized Contractor's breach of the license rights granted in this Agreement, breach of Your or an Authorized Contractor's obligation of confidentiality, or if You: (i) cease to do business or terminate Your business operations; or (ii) become insolvent or seek protection under any bankruptcy or liquidation or similar proceedings, or make an assignment of all or a majority of Your assets for the benefit of creditors.

8.3. Effect of Termination. Upon termination of this Agreement for any reason, the licenses and any rights granted under this Agreement will terminate, and You agree to irrevocably destroy, and will cause any of Your employees and Authorized Contractors to irrevocably destroy, the Licensed Software, Third Party Software and Unlicensed Software, and all portions of the foregoing, in Your possession or under Your control (including any portions merged into a design or Licensed Product not already distributed). Upon request, You agree to certify such destruction in writing to Intel. You may keep a single copy of the Licensed Software solely for archival purposes, but You will not continue to Use the Licensed Software or any portion thereof in development after termination of the Agreement. No refund for the Licensed Software will be provided to You upon termination of this Agreement.

9. Support and Maintenance Services.

9.1. Upon payment of the applicable Support fee, Intel or its Authorized Distributor, will for the Support period communicated to You at the time of Your license purchase or renewal, (i) provide Support and maintenance for the Licensed Software (including bug fixes, error corrections and any other updates) made generally available by Intel to licensees that purchase support and maintenance; (ii) use commercially reasonable efforts to provide fixes to defects in the Licensed Software that cause the Licensed Software not to conform in material respects with the specifications that are diagnosed as non-conformances, and are capable of replication by Intel; and (iii) use commercially reasonable efforts to respond by telephone or email to Your inquiries for Support for the Licensed Software. You agree that any information collected by Intel or the Authorized Distributor arising from or relating to Your requests for Support, including but not limited to design files compiled using the Licensed Software provided by You for purposes of design assistance, enhancement, and troubleshooting, may be used internally by Intel for the purpose of improving future versions of the Licensed Software and developing future products.

9.2. Exclusions. Except as otherwise described in Section 9.1, Intel will not have any obligation to provide any maintenance, support, or training, or to provide any error corrections, updates, upgrades, new versions, other modifications, or enhancements to the Licensed Software, Devices, or any Licensed Products. You will be responsible, at Your own expense, for providing technical support and training to Your customers and any other end users of the Licensed Software or Licensed Products, and Intel will have no obligation to support any of the foregoing. You will be solely responsible for, and Intel will have no obligation to honor, any warranties that You may provide to Your customers or to any other end users of the Licensed Products.

10. Limitation of Liability.

10.1. Intel's cumulative liability to You for all claims of any kind resulting from Intel's performance or breach of this Agreement or the Licensed Software or Support furnished under this Agreement, including any indemnity by Intel under this Agreement, will not exceed (i) the License Fees actually received by Intel from You under this Agreement for the Licensed Software and Support that is the subject of the claim, or (ii) $1,000, if the Licensed Software was provided at no charge to You, regardless of whether Intel has been advised of the possibility of those damages or whether any remedy set forth in this Agreement fails of its essential purpose or otherwise. This limitation of liability is cumulative and not per incident; the existence of more than one claim will not increase the limit.

10.2. Intel will not be liable for costs of procurement of substitutes, loss of profits, loss of use, interruption of business, or for any other special, consequential, punitive or incidental damages, however caused, whether for breach of warranty, contract, tort, negligence, strict liability or otherwise, irrespective of whether Intel has advance notice of the possibility of such damages. The limitation of liability set forth in Section 10 is a fundamental basis of this Agreement; and You understand and agree that Intel would not have entered into this Agreement without the limitation of liability.

10.3. THE LICENSED SOFTWARE MAY BE USED TO CREATE END PRODUCTS USED IN SAFETY-CRITICAL APPLICATIONS DESIGNED TO COMPLY WITH FUNCTIONAL SAFETY STANDARDS OR REQUIREMENTS ("SAFETY-CRITICAL APPLICATIONS"). IT IS YOUR RESPONSIBILITY TO DESIGN, MANAGE AND ASSURE SYSTEM-LEVEL SAFEGUARDS TO ANTICIPATE, MONITOR AND CONTROL SYSTEM FAILURES, AND YOU AGREE THAT YOU ARE SOLELY RESPONSIBLE FOR ALL APPLICABLE REGULATORY STANDARDS AND SAFETY-RELATED REQUIREMENTS CONCERNING YOUR USE OF THE LICENSED SOFTWARE IN SAFETY CRITICAL APPLICATIONS. YOU AGREE TO INDEMNIFY AND HOLD INTEL AND ITS REPRESENTATIVES HARMLESS AGAINST ANY DAMAGES, COSTS, AND EXPENSES ARISING IN ANY WAY OUT OF YOUR USE OF THE LICENSED SOFTWARE IN SAFETY-CRITICAL APPLICATIONS.

11. Choice of Law/Venue. This Agreement will in all respects be governed by, and construed and interpreted under, the laws of the United States of America and the State of Delaware, without reference to conflict of laws principles. The parties agree that the United Nations Convention on Contracts for the International Sale of Goods (1980) is specifically excluded from and will not apply to this Agreement. All disputes arising out of or related to this Agreement will be subject to the exclusive jurisdiction of the courts of the State of Delaware or of the Federal courts sitting in that State. Each party submits to the personal jurisdiction of those courts and waives all objections to that jurisdiction and venue for those disputes.

12. Export Control. You will not export, directly or indirectly, any Confidential Information, the Licensed Software, the Documentation or any product, service or technical data or system incorporating the Licensed Software without first obtaining any required license or other approval from the U.S. Department of Commerce or any other agency or department of the U.S. government. In the event of export from the United States or re-export from a foreign destination, You will ensure that the distribution and export or import of the product is in compliance with all laws, regulations, orders, or other restrictions of the U.S. Export Administration Regulations and the appropriate foreign government.

13. U.S. Government Restricted Rights. You acknowledge and agree that all software and software-related items licensed to You by Intel pursuant to this Agreement are "Commercial Computer Software" or "Commercial Computer Software Documentation" as defined in FAR 12.212 for civilian agencies and DFARS 227-7202 for military agencies (as amended) and in the event You are permitted under this Agreement to provide such items to the U.S. government, such items will be provided under terms that are at least as restrictive as the provisions of this Agreement. The contractor/manufacturer is Intel Corporation, 2200 Mission College Blvd., Santa Clara, CA 95054 and its licensors.

14. No Assignment. You may not delegate, assign or transfer this Agreement, the license(s) granted or any of Your rights or duties hereunder, expressly, by implication, by operation of law, or otherwise and any attempt to do so, without Intel's express prior written consent, will be null and void. Intel may assign, delegate and transfer this Agreement, and its rights and obligations hereunder, in its sole discretion.

15. Problem Reporter Notice, Consent and Opt-Out. The Problem Reporter feature of the Licensed Software will collect and provide certain information to Intel concerning Your use of the Licensed Software, in the event of a software crash. No logic designs or machine-executable binary form of cores used to program a Device that are processed with the Licensed Software will be collected or transmitted with the Problem Reporter. The types of data Problem Reporter transmits to Intel include: (i) Licensed Software tools (tools used, and version and build of the Licensed Software); (ii) platform data (operating system); and (iii) Licensed Software errors log data (previous exit status). You agree that You have been fully informed about the purposes for which Your information will be used, and You give Your consent for Intel to use this information both within and outside of the European Union for the purposes described in this Problem Reporter disclosure notice. You may disable or enable Problem Reporter at any time by making the appropriate setting in the Licensed Software.

16. Audit Rights. You agree to keep complete and accurate books and records which confirm Your compliance with the terms and conditions of this Agreement. Intel will have a right to audit Your facilities and records, provided that such audit: (i) will be conducted at reasonable times, upon reasonable prior written notice; and (ii) will not unreasonably interfere with Your normal business operations. This Section will survive for three (3) years after expiration or termination of this Agreement.

17. General Terms. This Agreement is entered into for the benefit of Intel, its licensors and Authorized Distributors, and all rights granted to You and all obligations owed to Intel, its licensors and the Authorized Distributors will be enforceable by Intel, its licensors and the Authorized Distributors. No modification of this Agreement will be binding unless in writing and signed by authorized representatives of each party. If any of the provisions of this Agreement are found to be in violation of applicable law, void, or unenforceable, then such provisions will be deemed to be deleted from the Agreement, but the remaining provisions of the Agreement will remain in full force and effect. You agree that the Agreement is the complete and entire agreement between You and Intel with respect to the subject matter hereof. No statements, promises or representations have been made by one party to the other, or are relied upon by either party when entering into this Agreement. All prior and contemporaneous discussions and negotiations, whether verbal or written, are merged into and superseded by the Agreement. Except as stated herein, no entity or person not a party hereto will have any interest under this Agreement, or be deemed to be a third party beneficiary of the Agreement. If the Agreement expires or terminates for any reason, all definitions in this Agreement and the rights, obligations, and restrictions under Sections 1 (Definitions); 2.2 (Use Restrictions); 2.6 (Authorized Contractors); 2.7.2 (Third Party Materials Disclaimer); 2.8 (Open Source Statement); 2.9 (Intellectual Property Rights Notices); 2.10 (Feedback); 2.11 (No Other Licenses or Intellectual Property Rights); 3 (Ownership and Future Development); 5 (Confidentiality and Publicity); 6 (Warranty Information); 7 (Indemnification); 8.3 (Effect of Termination); 10 (Limitation of Liability); 11 (Choice of Law/Venue); 12 (Export Control); 13 (U.S. Government Restricted Rights); 14 (No Assignment); 15 (Problem Reporter Notice, Consent and Opt-Out); 16 (Audit Rights); and 17 (General Terms) will survive expiration or termination of this Agreement.

END OF QUARTUS PRIME AND INTEL FPGA IP LICENSE AGREEMENT, VERSION 22.1std

===================================================================

THIRD-PARTY LICENSES

NOTE: The following third-party licenses and notices represent each
third-party contributor's use requirements for Your usage of any third-
party software incorporated into or provided in conjunction with the
Intel FPGA product(s) licensed under the Intel FPGA Software License Agreement
("Agreement").  The provisions contained in each such license apply
only to the respective Third-Party Components (as such term is defined
in the Agreement) and not to any Intel FPGA products licensed to You.

Quartus Prime THIRD-PARTY LICENSES
------------------------------------------------------------------
1. 7-zip 18.05 (LGPL v. 2.1, BSD 3-clause, unRAR License)
2. Alphanum 1.0 (libpng/zlib License)
3. Apache Xerces C++ 3.2.2 (Apache v. 2.0 license)
4. backports.functools_lru_cache 1.5 (MIT)
5. Base64 decoder 1.0 (Zlib License)
6. boost 1.53.0 (MIT-style License)
7. Bottle 0.12.21 (MIT License)
8. buddy 2.2 (BSD-style License)
9. bwidget 1.4.1 (BSD-style License)
10. Cajun 2.0.1 (3 Clause BSD License)
11. certifi 2021.10.8 (Mozilla Public License 2.0 (MPL 2.0))
12. chardet 3.0.4 (GNU Lesser General Public License v2.1)
13. charset-normalizer 3.2.0 (MIT License)
14. cheroot 6.5.4 (BSD 3 Clause License)
15. CherryPy 18.1.0 (3 Clause BSD License)
16. defusedxml 0.6.0 (Python Software Foundation License Version 2)
17. Editline Library (libedit) 0:42:0 (NetBSD License)
18. GD 2.0.34 (BSD-style License)
19. IBM.ICU 4.4.2 (IBM ICU License and additional Third Party terms)
20. ICU 69.1 (IBM License and additional third party terms)
21. idna 2.8 (BSD)
22. INCR TCL 4.0 (BSD-Style License)
23. jaraco.functools 2.0 (MIT)
24. jdbc sqlite 20120209 (Apache v. 2.0 license)
25. jpeg 6b (Indedendent JPEG Group License)
26. jQuery 1.11.3 (MIT License)
27. jQuery UI 1.10.2 (MIT License)
28. jQuery UI Layout Plug-in 1.3.0.rc30.79 (MIT License, GPL v.3 License)
29. jre 8 (GPL v.2.0 License)
30. libaji_client 22.2 (MIT)
31. LIBCURL 8.1.2 (MIT/X Derivative License)
32. Libelf 0.8.10 (LGPL v. 2.1 License)
33. Liberty Parser 2.6 (SYNOPSYS Open Source License Version 1.0)
34. libffi 3.3 (Free Software)
35. libunwind 1.4.0 (MIT)
36. Mac4Lin 1.0 (LGPL v. 2.1 License)
37. make 3.81 (GPL v. 2.0 License)
38. metis 4.0.1 (GPL v. 2.0 License)
39. more-itertools 5.0.0 (MIT License)
40. more-itertools 6.0.0 (MIT License)
41. MSDN Sample Code  (Microsoft Developer Agreement)
42. Normalize.css 2.1.3 (MIT License)
43. OpenOCD 0.11.0 (General Public License Version 2.0 or later)
44. OpenSSL 1.1.1u (OpenSSL License and the original SSLeay (The OpenSSL License is Apache License 1.0 and SSLeay License bears some similarity to a 4-clause BSD License))
45. Peewee 3.14.0 (MIT License)
46. Peewee 3.8.2 (MIT License)
47. Perl 5.30.3 (GPL v. 1.0 or the Artistic License)
48. PicNet Table Filter  (MIT License)
49. Protobuf 3.4.0 (BSD 3 Clause License)
50. psutil 5.9.5 (BSD 3-Clause License)
51. Python 3.8.17 (PSF License for Python 3.8.17)
52. [foss] pytz (2018.9)
53. Requests 2.31.0 (Apache v. 2.0 license)
54. safestringlib 20170614 (MIT License)
55. six 1.15.0 (MIT)
56. sqlite 3.40.1 (Public Domain)
57. superlu 2.2.0 (BSD 3 Clause License)
58. Tablelist 5.5 (MIT style license)
59. TableSorter 2.7.3 (MIT License, GPL v. 3.0 Licenses)
60. tbb 4.2.2 (GPL v.2.0 License)
61. TCL-TK 8.6 (BSD-style License)
62. tcldom 3.0 (BSD Style License)
63. tcllib 1.11 (BSD 4 Clause License)
64. tclsoap 1.6.7 (MIT License)
65. tclxml 3.2 (BSD style License)
66. tempora 1.14 (MIT)
67. TinyXML2 7.0.1 (zlib)
68. tktable 2.10 (Tcl/Tk license)
69. Twitter Bootstrap 3.0.3 (Apache v. 2.0 License)
70. Twitter Bootstrap 3.3.6 (MIT License)
71. Underscore.js 1.4.4 (MIT License)
72. unzip 6.10c23 (Info-ZIP license)
73. urllib3 1.26.6 (MIT)
74. xcb-util-image 0.4.0 (MIT)
75. xcb-util-keysyms 0.4.0 (MIT)
76. xcb-util-renderutil 0.3.9 (MIT)
77. xcb-util-wm 0.4.1 (MIT)
78. xcb-util 0.4.0 (MIT)
79. xmlgen 1.4 (Apache v. 2.0 license)
80. zc.lockfile 1.4 (Zope Public License (ZPL 2.1))
81. ZLIB 1.2.13 (Zlib License)

Intel FPGA IP THIRD-PARTY LICENSES
------------------------------------------------------------------
1. Micrium uC/OS II 2.93.0 (Apache 2.0)
2. antlr 2.7.2 (BSD 4 Clause License)
3. antlr 4.5.1 (BSD 3 Clause License)
4. appframework 1.03 (LGPL v. 2.1 License)
5. asm 3.1 (BSD 3 Clause License)
6. beansbinding 1.2.1 (LGPL v. 2.1 License)
7. JGoodies Binding 2.0.6 (BSD 3 Clause License)
8. binutils 2.37.50 (GNU General Public License v3.0 or later)
9. boost 1.38.0 (MIT-style License)
10. boost 1.65.0 (MIT-style License)
11. castor 1.0.3 (Apache v. 2.0 and Intalio BSD-style Licenses)
12. castor 1.2 (Apache v. 2.0 and Intalio BSD-style Licenses)
13. checker-framework 2.3.0 (GPL v. 2 License)
14. checkstyle 4.2 (LGPL v. 2.1 License)
15. cli 1.1 (Apache v. 2.0 License)
16. cloog 0.18.1 (LGPL v2 License)
17. cobertura 1.8 (GPL v. 2 License)
18. codesourcery 2019.05-04 (CodeSourcery Inc License)
19. Apache Common Collections 4.1 (Apache License 2.0)
20. Apache Common Collections 4.3 (Apache License 2.0)
21. Apache Common Lang 3.7 (Apache License 2.0)
22. commons-beanutils 1.6 (Apache v. 1.1 License)
23. commons-digester 1.5 (Apache v. 1.1 License)
24. commons-logging 1.1 (Apache v. 2.0 License)
25. commons-logging 1.2 (Apache v. 2.0 License)
26. commons-math 3.5 (Apache v. 2.0 License)
27. commons-pool 1.2 (Apache v. 2.0 License)
28. cpputest 3.8 (BSD 3-clause "New" or "Revised" License)
29. DockingFrames 1.1.2_20b (LGPL v. 2.1 License)
30. DockingFrames 1.1.2p12c (LGPL v. 2.1 License)
31. eclipse-cpp-mars-2 4.5.0 (Eclipse Public License v 1.0)
32. expat 2.5.0 (MIT License)
33. explicitlayout 3.0 (LGPL v. 2.1 License)
34. fmt 4.0.0 (BSD 2-clause "Simplified" License)
35. forms_rt 6.0 (Apache v. 2.0 License)
36. gcc 12.2.1 (GPL v. 3 License)
37. gdb 11.2.90 (GPL v. 3 License)
38. gmp 6.2.1 (LGPL v. 3 License)
39. gnu 1.2.5 (GPL v. 2 License)
40. guava-libraries 27.1 (Apache v. 2.0 License)
41. hamcrest 1.3 (BSD 3 Clause License)
42. isl 0.25 (MIT License)
43. jacl 1.3.2a (Jacl Software License)
44. javasysmon 0.3.5 (BSD 2 Clause License)
45. jaxb-ri 2.3.0 (GPL v. 2.0, and CDDL v. 1.1 Licenses plus Classpath Exception)
46. jaxb-ri 2.2.7 (CDDL v. 1.1; GPL v. 2 Classpath Exception)
47. jaxb-xew-plugin 1.4 (LGPL v. 3 License)
48. jaxb2-basics-annotate 1.0.1 (BSD 2 Clause License)
49. jaxb2-basics-tools 0.9.0 (BSD 3 Clause License)
50. jaxen 1.1.1 (BSD 3 Clause License)
51. jaxen 1.3 (BSD 4 Clause License)
52. jcommon 1.0.16 (LGPL v. 3 License)
53. JDOM 1.0 (BSD-style License)
54. JFreeChart 1.0.13 (LGPL v. 3 License)
55. JGraphX 2.2.0.2 (BSD 3 Clause License)
56. jline 2.12 (BSD 3 Clause License)
57. Jline3 3.7.0 (BSD 3-clause "New" or "Revised" License)
58. jsap 2.0a (LGPL v. 2.1 License)
59. jsr173 1.0 (Apache v. 2.0 License)
60. junit 3.8.1 (Common Public License v. 1.0)
61. junit 4.0 (Common Public License v. 1.0)
62. junit 4.1 (Common Public License v. 1.0)
63. l2fprod 7.3 (Apache v. 2.0 License)
64. libstdc v3 (GPL v. 3 License)
65. looks 2.0.1 (BSD 2 Clause License)
66. make 3.81 (GPL v. 2 License)
67. miglayout15 3.0.3 (BSD 2 Clause License)
68. miglayout 4.0 (BSD)
69. mpc 1.2.1 (LGPL v. 3 License)
70. mpfr 4.0.2 (LGPL v. 3 License)
71. mpir 2.2.1 (LGPL v. 3 License)
72. mpir 3.0.0 (LGPL v. 3 License)
73. mydoggy 1.4.2 (LGPL v. 3 License)
74. ncurses 6.3
75. netbeans-swing-outline 6.9 (LGPL v. 2.1, GPL v. 2.0, and CDDL v. 1 Licenses plus Classpath Exception)
76. newlib 4.2.0 (Red Hat and BSD 3 Clause Licenses)
77. quickserver 1.4.7 (LGPL v.2.1 License)
78. swingworker 3 (MPL v. 1.1 and LGPL v. 2.1 Licenses)
79. symphony 5.4.5 (Eclipse Public License v. 1.0)
80. systemc 2.2.0 (SystemC Open Source License v. 3.3)
81. velocity 1.4 (Apache v. 2.0 License)
82. wraplf 0.2 (Apache v. 2.0 License)
83. xalan 1.2.2 (Apache v. 2.0 License)
84. xerces-c 3.2.2 (Apache v. 2.0 License)
85. xerces 2.12.0 (Apache v. 1.1 License)
86. xmlbeans 2.2.0 (Apache v. 2.0 License)
    " > $t; whiptail --title "Software License Agreement" --scrolltext --textbox $t 20 78; rm $t
    if (! whiptail --title "Software License Agreement" --yesno "           Full license: http://fpgasoftware.intel.com/eula/\n\n           Do you accept the terms of the license agreement?" 9 75) then
        whiptail --title "Quartus Prime Lite Installer" --msgbox "                 Installation aborted by user request." 7 75
        exit 1
    fi
}

options() {
    DEFAULT_PATH=$INSTALL_PATH
    export NEWT_COLORS='root=,blue'
    INSTALL_PATH=$(whiptail --inputbox "Please enter the installation path:" 8 75 "$DEFAULT_PATH" --title "Installation Path" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if ! [ $exitstatus = 0 ]; then
        whiptail --title "Quartus Prime Lite Installer" --msgbox "                 Installation aborted by user request." 7 75
        exit 1
    fi
    if [ -d "$INSTALL_PATH" ]; then
        export NEWT_COLORS='root=,yellow'
        if (whiptail --title "Quartus Prime Lite Installer" --yesno "                 The installation path already exists.\n                      Do you want to overwrite it?" 8 75) then
            export NEWT_COLORS='root=,red'
            if (whiptail --title "WARNING" --yesno "                             ARE YOU SURE?\n\nTHIS WILL DELETE $INSTALL_PATH AND ITS CONTENTS. THERE IS NO WAY BACK!!!" 10 75) then
                sudo rm -rf "$INSTALL_PATH"
            else
                options
            fi
        else
            options
        fi
    fi
    export NEWT_COLORS='root=,blue'
    USER_INPUT=$(whiptail --title "Components Selection" --checklist \
    "Choose the components to install" 17 78 11   \
    "quartus" "Quartus Prime Lite Edition              (Required)  " ON \
    "quartus_help" "Quartus Help Files" OFF \
    "devinfo" "Device Info                             (Required)  " ON \
    "arria_lite" "Arria Lite Edition" OFF \
    "cyclone" "Cyclone Devices (IV E, IV GX)        (Recommended)  " ON \
    "cyclone10lp" "Cyclone 10 LP Series" OFF \
    "cyclonev" "Cyclone V Devices" OFF \
    "max" "MAX Devices" OFF \
    "max10" "MAX 10 Devices" OFF \
    "quartus_update" "Quartus Updates" OFF \
    "questa_fse" "Questa (Zero cost license)           (Recommended)  " ON 3>&1 1>&2 2>&3)
    QUARTUS_ENABLE=false
    QUARTUS_HELP_ENABLE=false
    DEVINFO_ENABLE=false
    ARRIA_LITE_ENABLE=false
    CYCLONE_ENABLE=false
    CYCLONE10LP_ENABLE=false
    CYCLONEV_ENABLE=false
    MAX_ENABLE=false
    MAX10_ENABLE=false
    QUARTUS_UPDATE_ENABLE=false
    QESTA_FSE_ENABLE=false
    QUESTA_FE_ENABLE=false
    exit_status=$?
    if [ $exit_status -eq 0 ]; then
        eval CHOICES=($USER_INPUT)
        for choice in "${CHOICES[@]}"; do
            echo $choice
            case $choice in
                "quartus") QUARTUS_ENABLE=true ;;
                "quartus_help") QUARTUS_HELP_ENABLE=true ;;
                "devinfo") DEVINFO_ENABLE=true ;;
                "arria_lite") ARRIA_LITE_ENABLE=true ;;
                "cyclone") CYCLONE_ENABLE=true ;;
                "cyclone10lp") CYCLONE10LP_ENABLE=true ;;
                "cyclonev") CYCLONEV_ENABLE=true ;;
                "max") MAX_ENABLE=true ;;
                "max10") MAX10_ENABLE=true ;;
                "quartus_update") QUARTUS_UPDATE_ENABLE=true ;;
                "questa_fse") QUESTA_FSE_ENABLE=true ;;
            esac
        done
    elif [ $exit_status -eq 1 ]; then
        whiptail --title "Quartus Prime Lite Installer" --msgbox "                 Installation aborted by user request." 7 75
        exit 1
    fi
    if (! whiptail --title "Quartus Prime Lite Installer" --yesno "                    The installation will now begin.\n\n                       Do you want to continue?" 9 75) then
        whiptail --title "Quartus Prime Lite Installer" --msgbox "                 Installation aborted by user request." 7 75
        exit 1
    fi
}

installation() {
    :
    # {{{## REPLACE BY DISTRO SPECIFIC INSTALL SCRIPT ##}}}
}

questa_license() {
    export NEWT_COLORS='root=,blue'
    whiptail --title "Quartus Prime Lite Installer" --msgbox "Questa needs a free to use license in order to work.\n\n                    Please, read the following guide:\n https://miguelovila.com/posts/installing-quartus-prime-22-and-questa/" 10 75
    LICENSE_PATH=$(whiptail --inputbox "Please enter the license path:" 8 75 "/path/to/license.dat" --title "License Path" 3>&1 1>&2 2>&3)
    exitstatus=$?
    if ! [ $exitstatus = 0 ]; then
        whiptail --title "Quartus Prime Lite Installer" --msgbox "                 Installation aborted by user request." 7 75
        exit 1
    fi
    cp "$LICENSE_PATH" "$INSTALL_PATH/questa_license.dat"
    echo 'export LM_LICENSE_FILE='$INSTALL_PATH'/questa_license.dat' >> ~/.bashrc
}

final_message() {
    whiptail --title "Quartus Prime Lite Installer" --msgbox "                 Installation completed successfully." 7 75
}

check_script_deps

agreements

options

installation

if [ "$QUESTA_FSE_ENABLE" == "true" ]; then
    questa_license
fi

final_message

exit 0
