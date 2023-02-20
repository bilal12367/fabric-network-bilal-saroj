import { fileURLToPath } from 'url';
import { dirname } from 'path';
import { getCaInfo, getCaUrl, getCCPJsonFile, getWalletPath } from '../utils/helper.js';
import logger from '../logger/logger.js';
import { DefaultEventHandlerStrategies, Gateway, Wallets } from 'fabric-network';
import FabricCAServices from 'fabric-ca-client';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const enrollAdmin = async (orgname, ccp) => {
    logger.info("Enrolling Admin for " + orgname)
    try {
        const caInfo = await getCaInfo(orgname, ccp);
        const caTLSCACerts = caInfo.tlsCACerts.pem;
        const ca = new FabricCAServices(caInfo.url, { trustedRoots: caTLSCACerts, verify: false }, caInfo.caName)

        const walletPath = await getWalletPath(orgname)
        const wallet = await Wallets.newFileSystemWallet(walletPath);

        const identity = await wallet.get("admin");
        if (identity) {
            logger.fatal("Admin identity is already registered !!! in enroll Admin!!!")
            return
        }

        const enrollment = await ca.enroll({ enrollmentID: 'admin', enrollmentSecret: 'adminpw' })
        let x509Identity;
        if (orgname == 'Org1') {
            x509Identity = {
                credentials: {
                    certificate: enrollment.certificate,
                    privateKey: enrollment.key.toBytes(),
                },
                mspId: 'Org1MSP',
                type: 'X.509',
            };
        } else if (orgname == 'Org2') {
            x509Identity = {
                credentials: {
                    certificate: enrollment.certificate,
                    privateKey: enrollment.key.toBytes(),
                },
                mspId: 'Org2MSP',
                type: 'X.509',
            };
        }

        await wallet.put('admin', x509Identity);
        console.log('Successfully enrolled admin user "admin" and imported it into the wallet');
    } catch (error) {
        logger.error("From Enroll Admin: ", error)
        console.log(error)
    }
}

export const registerIdentity = async (req, res, next) => {
    const username = req.body.username;
    const orgname = req.body.orgname;


    logger.debug("Endpoing: /api/register")
    logger.debug("Request Body: ", req.body)
    if (!username || !orgname) {
        res.status(500).json({ message: "Bad Request" })
    }

    const ccp = await getCCPJsonFile(orgname);
    const caUrl = await getCaUrl(orgname, ccp);
    const ca = new FabricCAServices(caUrl);

    const walletPath = await getWalletPath(orgname);
    const wallet = await Wallets.newFileSystemWallet(walletPath);

    var userIdentity = await wallet.get(username)
    if (userIdentity) {
        logger.fatal("UserIdentity of " + username + " already exists!!!")
        res.status(409).json({ message: "User Already Exists." })
        return
    }

    var adminIdentity = await wallet.get("admin")
    if (!adminIdentity) {
        logger.fatal("AdminIdentity not registered!!!")
        await enrollAdmin(orgname, ccp);
        adminIdentity = await wallet.get("admin")
    }

    const provider = wallet.getProviderRegistry().getProvider(adminIdentity.type);
    const adminUser = await provider.getUserContext(adminIdentity, 'admin');
    let secret, x509Identity, enrollment;
    try {
        // Register the user, enroll the user, and import the new identity into the wallet.
        secret = await ca.register({ affiliation: await (orgname == 'Org1' ? 'org1.department1' : 'org2.department1'), enrollmentID: username, role: 'client' }, adminUser);
        enrollment = await ca.enroll({ enrollmentID: username, enrollmentSecret: secret })
        // const secret = await ca.register({ affiliation: 'org1.department1', enrollmentID: username, role: 'client', attrs: [{ name: 'role', value: 'approver', ecert: true }] }, adminUser);
        if (orgname == "Org1") {
            x509Identity = {
                credentials: {
                    certificate: enrollment.certificate,
                    privateKey: enrollment.key.toBytes(),
                },
                mspId: 'Org1MSP',
                type: 'X.509',
            };
        } else if (orgname == "Org2") {
            x509Identity = {
                credentials: {
                    certificate: enrollment.certificate,
                    privateKey: enrollment.key.toBytes(),
                },
                mspId: 'Org2MSP',
                type: 'X.509',
            };
        }
        await wallet.put(username, x509Identity)

        res.status(200).json({
            username,
            message: "User Successfully enrolled.",
            x509Identity
        })
    } catch (error) {
        // return error.message
        console.log(error)
        res.status(500).json({ error })
    }

}
