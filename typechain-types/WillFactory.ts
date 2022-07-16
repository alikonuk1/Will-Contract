/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type {
  BaseContract,
  BigNumber,
  BigNumberish,
  BytesLike,
  CallOverrides,
  ContractTransaction,
  PayableOverrides,
  PopulatedTransaction,
  Signer,
  utils,
} from "ethers";
import type {
  FunctionFragment,
  Result,
  EventFragment,
} from "@ethersproject/abi";
import type { Listener, Provider } from "@ethersproject/providers";
import type {
  TypedEventFilter,
  TypedEvent,
  TypedListener,
  OnEvent,
  PromiseOrValue,
} from "./common";

export interface WillFactoryInterface extends utils.Interface {
  functions: {
    "Dao()": FunctionFragment;
    "buildWill(address,uint256)": FunctionFragment;
    "getCurrentTime()": FunctionFragment;
  };

  getFunction(
    nameOrSignatureOrTopic: "Dao" | "buildWill" | "getCurrentTime"
  ): FunctionFragment;

  encodeFunctionData(functionFragment: "Dao", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "buildWill",
    values: [PromiseOrValue<string>, PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "getCurrentTime",
    values?: undefined
  ): string;

  decodeFunctionResult(functionFragment: "Dao", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "buildWill", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "getCurrentTime",
    data: BytesLike
  ): Result;

  events: {
    "NewWill(address,address,address)": EventFragment;
  };

  getEvent(nameOrSignatureOrTopic: "NewWill"): EventFragment;
}

export interface NewWillEventObject {
  arg0: string;
  arg1: string;
  arg2: string;
}
export type NewWillEvent = TypedEvent<
  [string, string, string],
  NewWillEventObject
>;

export type NewWillEventFilter = TypedEventFilter<NewWillEvent>;

export interface WillFactory extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: WillFactoryInterface;

  queryFilter<TEvent extends TypedEvent>(
    event: TypedEventFilter<TEvent>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TEvent>>;

  listeners<TEvent extends TypedEvent>(
    eventFilter?: TypedEventFilter<TEvent>
  ): Array<TypedListener<TEvent>>;
  listeners(eventName?: string): Array<Listener>;
  removeAllListeners<TEvent extends TypedEvent>(
    eventFilter: TypedEventFilter<TEvent>
  ): this;
  removeAllListeners(eventName?: string): this;
  off: OnEvent<this>;
  on: OnEvent<this>;
  once: OnEvent<this>;
  removeListener: OnEvent<this>;

  functions: {
    Dao(overrides?: CallOverrides): Promise<[string]>;

    buildWill(
      willUser: PromiseOrValue<string>,
      expiration: PromiseOrValue<BigNumberish>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    getCurrentTime(overrides?: CallOverrides): Promise<[BigNumber]>;
  };

  Dao(overrides?: CallOverrides): Promise<string>;

  buildWill(
    willUser: PromiseOrValue<string>,
    expiration: PromiseOrValue<BigNumberish>,
    overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  getCurrentTime(overrides?: CallOverrides): Promise<BigNumber>;

  callStatic: {
    Dao(overrides?: CallOverrides): Promise<string>;

    buildWill(
      willUser: PromiseOrValue<string>,
      expiration: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    getCurrentTime(overrides?: CallOverrides): Promise<BigNumber>;
  };

  filters: {
    "NewWill(address,address,address)"(
      arg0?: null,
      arg1?: null,
      arg2?: null
    ): NewWillEventFilter;
    NewWill(arg0?: null, arg1?: null, arg2?: null): NewWillEventFilter;
  };

  estimateGas: {
    Dao(overrides?: CallOverrides): Promise<BigNumber>;

    buildWill(
      willUser: PromiseOrValue<string>,
      expiration: PromiseOrValue<BigNumberish>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    getCurrentTime(overrides?: CallOverrides): Promise<BigNumber>;
  };

  populateTransaction: {
    Dao(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    buildWill(
      willUser: PromiseOrValue<string>,
      expiration: PromiseOrValue<BigNumberish>,
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    getCurrentTime(overrides?: CallOverrides): Promise<PopulatedTransaction>;
  };
}