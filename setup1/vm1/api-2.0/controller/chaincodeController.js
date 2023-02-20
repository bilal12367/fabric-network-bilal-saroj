import { fileURLToPath } from 'url';
import { dirname } from 'path';
import { getCCPJsonFile, getWalletPath } from '../utils/helper.js';
import logger from '../logger/logger.js';
import { DefaultEventHandlerStrategies, Gateway, Wallets } from 'fabric-network';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);



export const createCar = async (req, res, next) => {
    logger.info("Endpoint: /api/addCar")
    logger.info("Request Body: ",req.body)
    const orgname = req.body.orgname;
    const username = req.body.username;
    const args = req.body.args;

    try {


        const ccp = await getCCPJsonFile(orgname) //JSON.parse(ccpJSON);

        // Create a new file system based wallet for managing identities.
        const walletPath = await getWalletPath(orgname) //path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        
        // Check to see if we've already enrolled the user.
        let identity = await wallet.get(username);
        if (!identity) {
            logger.fatal("Identity not registered !!! ", username)
            return
        }



        const connectOptions = {
            wallet, identity: username, discovery: { enabled: true, asLocalhost: false },
            eventHandlerOptions: {
                commitTimeout: 100,
                strategy: DefaultEventHandlerStrategies.NETWORK_SCOPE_ALLFORTX
            }
        }

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, connectOptions);

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');

        const contract = network.getContract('fabcar');
        const result = await contract.submitTransaction('createCar', args[0], args[1], args[2], args[3], args[4]);

        logger.info("Successfully submitted transaction!!!")
        res.status(200).json({result:result, message: "Successfully submitted transaction!!!"})
    } catch (error) {
        logger.error(error)
        res.status(500).json(error)
    }
}

export const getCar = async (req, res, next) => {
    logger.info("Endpoint: /api/getCar")
    logger.info("Request Body: ",req.body)
    const orgname = req.body.orgname;
    const username = req.body.username;
    const args = req.body.args;

    try {


        const ccp = await getCCPJsonFile(orgname) //JSON.parse(ccpJSON);

        // Create a new file system based wallet for managing identities.
        const walletPath = await getWalletPath(orgname) //path.join(process.cwd(), 'wallet');
        const wallet = await Wallets.newFileSystemWallet(walletPath);
        
        // Check to see if we've already enrolled the user.
        let identity = await wallet.get(username);
        if (!identity) {
            logger.fatal("Identity not registered !!! ", username)
            return
        }



        const connectOptions = {
            wallet, identity: username, discovery: { enabled: true, asLocalhost: false },
            eventHandlerOptions: {
                commitTimeout: 100,
                strategy: DefaultEventHandlerStrategies.NETWORK_SCOPE_ALLFORTX
            }
        }

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, connectOptions);

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');

        const contract = network.getContract('fabcar');

        // const result = await contract.submitTransaction('createCar', args[0], args[1], args[2], args[3], args[4]);
        const result = await contract.evaluateTransaction('queryCar',args[0])
        logger.info("Successfully submitted transaction!!!")
        const resultJSON = JSON.parse(result.toString())
        res.status(200).json({result:resultJSON, message: "Successfully submitted transaction!!!"})
    } catch (error) {
        logger.error(error)
        res.status(500).json(error)
    }
}

